class Payment < ActiveRecord::Base

  MAX_ATTEMPTS = 9

  include IpAddressAttribute
  ip_address :ip
  search_methods :ip

  attr_accessor :store, :cvv, :payment_errors, :public_payment_errors, :transaction_code, :custom_amount, :attempts #, :payment_type
  validates :cvv, :presence => true, :on => :create, :if => proc { |r| r.type == 'CreditCardPayment' && r.card_id }

  attr_accessor :test_response

  validates_each :public_payment_errors, :allow_blank => true do |record, attr, errors|
    errors && errors.each do |type, message|
      record.errors.add(type, message)
    end
  end

  self.inheritance_column = 'type'

  # submitter is always the current user, model default in controller
  belongs_to :submitter, :class_name => 'User'

  # student is whose active shopping cart is paid for
  belongs_to :student

  belongs_to :card, :class_name => 'CreditCard'

  def credit_cards
    c = if student && store
      student.cards(store)
    else
      []
    end
    #logger.debug "student = #{student} && store = #{store.inspect} \n ccs = #{c.inspect}"
    c
  end

  TYPES = [:credit_card_payment, :gift, :cheque, :invoice, :retake, :coursehorse]
  TYPE_NAMES = TYPES.map(&:to_s)
  TYPE_CLASS_NAMES = TYPE_NAMES.map(&:classify)

  # this has to come before reading in subclasses
  accepts_nested_attributes_for :card, :reject_if => proc { |attrs| attrs['mandatory'].blank? }


  # order id is generated at every creation and used for transaction code by the controller
  # this order id is important and used by the gateway to identify payments for later refund etc.
  default :amount => proc { |r| r.set_amount },
    :order_id => proc { |r| r.class.generate_order_id },
    :attempts => 0,
    :payment_errors => proc { Hash.new },
    :public_payment_errors => proc { Hash.new }

  #before_validation :set_type

  def set_type
    self.type = payment_type
  end

  def payment_options
    @payment_options ||= TYPE_CLASS_NAMES.select do |type|
      klass = type.constantize
      klass.new.authorized?(self)
    end
  end

  def can_have_card?
    payment_options.include?('CreditCardPayment')
  end

  # we allow the student field to be nil, in which case all the checked out
  # payments submitted by submitter will be paid.
  validates :student, :existence => true, :allow_nil => true
  validates :submitter, :existence => true, :allow_nil => true

  # if student is specified it has to be represented by submitter
  validates_each :submitter, :on => :create, :allow_nil => true do |record, attr, value|
    record.errors.add :submitter, "is invalid: #{record.submitter.name} not authorized to pay for #{record.student.name}" unless record.student.nil? || record.authorized_submitter?
    record.errors.add :submitter, "is not authorized to make a payment by #{record.type.humanize}" unless record.type.nil? || record.authorized?
  end

  def authorized?(*args)
    transaction_code == 'test'
  end

  def authorized_submitter?
    student.is_a?(Student) && submitter.is_a?(User) &&
      (submitter.admin? || student== submitter || student.created_by == submitter)
  end

  def payer
    submitter.admin? && student || submitter
  end

  #has_many :signups
  # a successful payment has purchases
  has_many :purchases, :class_name => 'Signup', :dependent => :delete_all
  # a failed payment has failed purchases
  has_and_belongs_to_many :failed_purchases, :class_name => 'Signup',
    :join_table => 'failed_payments_purchases'

  # the amount is calculated based on the shopping cart, set via signups_controller
  composed_of :amount, :class_name => 'Money',
    :mapping => [%w(amount cents)],
    :allow_nil => true,
    :converter => proc { |c| c.blank? ? Struct.new(:cents).new : c.is_a?(Money) ? c : Money.new(c.to_f * 100) }

  validates_each :transaction_code, :on => :create do |record, attr, value|
    record.errors.add(attr, "invalid, session changed (%s vs %s)" % [value, record.order_id]) unless value == record.order_id || value == 'test'
  end

  validates_each :amount, :on => :create, :unless => proc { |r| !r.custom_amount.blank? || r.transaction_code.blank? } do |record, attr, value|
    record.errors.add(attr, "invalid, amounts differ (%s vs %s)" % [value, record.calculate_amount]) unless value == record.calculate_amount
  end

  validates :custom_amount, :on => :create, :allow_blank => true, :numericality => true

  before_validation :set_amount

  def set_amount
    if new_record?
      self.submitter ||= student
      self.amount ||= calculate_amount
    end
  end

  def calculate_amount
    shopping_cart.map(&:price).sum
  end

  def shopping_cart
    Signup.shopping_cart(student_id || submitter_id).where(:transaction_code.eq => order_id)
  end

  # acceptance of terms and conditions done via validation and a nonpersistent accessor
  attr_accessor :terms_and_conditions
  validates :terms_and_conditions, :acceptance => {:message => 'You have to read and agree to our terms and conditions'}

  # order id is generated as an MD5 hexdigest string or similar
  def self.generate_order_id
    (36**(13) + rand(36**14)).to_s(36)
  end

  def charged?
    !!completed_at
  end

  def failed?
    !success
  end

  def succeed!
    self.completed_at = Time.now
    self.success = true
    save
    (self.purchases = shopping_cart.readonly(false)).each &:succeed
    success
  end

  def fail!
    self.completed_at = Time.now
    self.success = false
    self.attempts = attempts.to_i + 1
    self.failed_with = payment_errors.to_a.to_sentence
    valid?
    save(:validate => false)
    # many to many association of failed purchases
    self.failed_purchases = shopping_cart
    success
  end

  def charge(test=false, success=false)
    # make sure under no circumstances is charge called more than once.
    raise(ArgumentError, "Attempted to recharge a payment") if charged?

    if test then
      unless success
        errors.add(:payment, 'failed: force failure')
        payment_errors[:charge] = 'force failure'
      end
    elsif attempts.to_i > MAX_ATTEMPTS
      success = false
      errors.add(:payment, 'failed: maximum number of attempts reached. please reload shopping card')
      payment_errors[:attempts] = 'maximum number of attempts reached'
    else
      success = amount <= 0 || charge!
    end

    success ? succeed! : fail!
  end

  def charge!
    true
  end

  scope :amount_in_usd_lt, lambda { |a|
    where(:amount.lt => a.to_i*100)
  }

  scope :amount_in_usd_gt, lambda { |a|
    where(:amount.gt => a.to_i*100)
  }

  after_create :send_invoice


end
