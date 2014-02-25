class CreditCard < ActiveRecord::Base

  ATTRS = [:card_type, :number, :month, :year, :first_name, :last_name, :cvv]
  CCATTRS = [:type, :number, :month, :year, :first_name, :last_name, :verification_value]

  attr_accessor *ATTRS
  attr_accessor :mandatory, :card, :store, :cvv, :remember

  # remember credit card details in external store optionally passed by controller layer (cookie)
  default :remember => true

  belongs_to :student
  belongs_to :address, :autosave => true

  accepts_nested_attributes_for :address,
                                :allow_destroy => true,
                                :reject_if => proc { |attrs| attrs['mandatory'] != "true" }

  has_many :payments

  validates :student, :existence => true
  validates :address, :associated => true

  before_validation :set_addressable

  validates_each :address, :allow_blank => true do |record, attr_name, value|
    record.errors.add attr_name, "does not belong to student" unless value.addressable == record.student
  end

  before_validation :set_name
  validates :name, :format => { :with => /\A[X\-]*\d\d\d\d\Z/ }

  validates :card, :credit_card => {:requires_verification_value => true},
            :on => :create

  # needed?
  def supported_cardtypes
    ActiveMerchant::Billing::LinkpointGateway.supported_cardtypes
  end

  def credit_card(store, cvv)
    self.card ||= init_credit_card(store)
    card.verification_value ||= cvv
    #logger.debug "CC = #{card.inspect}"
    card
  end

  def available?(store)
    get_store_value(store)
  end

  before_create :set_store_value

  private

  def init_credit_card(store)
    self.store = store
    attrs = new_record? ? credit_card_attrs : get_store_value
    return unless attrs
    options = {}
    CCATTRS.each_with_index { |a, i| options[a] = attrs[i] }
    ActiveMerchant::Billing::CreditCard.new(options)
  end

  def credit_card_attrs
    @credit_card_attrs ||= ATTRS.map { |a| send(a) }
  end

  def get_store_value(store = store)
    value = store_key && store[store_key.to_sym]
    value.split('&') if value
  end

  def set_name
    self.name = card.display_number if new_record? && card
  end

  def set_addressable
    address.addressable ||= student if address
  end

  def set_store_value
    return unless store || remember != '1'
    self.store_key = "_cc_#{(36**(7) + rand(36**8)).to_s(36)}"
    value = {
        :value => credit_card_attrs,
        :expires => 1.month.since(card.expiry_date.expiration)
    }
    store[store_key] = value
    #logger.debug "cookies[#{store_key}] = #{value.inspect}"
  end


end
