class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable


  extend FriendlyId
  friendly_id :url_name, :use => :slugged

  def url_name
    admin? || student? ? name + id.to_s : name
  end

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :discount, :invoiceable, :mandatory, :created_by, :active,
    :first_name, :last_name, :position, :parent_id, :company_id, :company_name

  ROLES = [:student, :admin, :teacher]

  validates :email, :email => true, :uniqueness => true
  validates :first_name, :last_name, :presence => true

  validates :role, :inclusion => ROLES.map { |x| x.to_s.classify }
  # to correct dependency bug with single table inheritance
  #http://stackoverflow.com/questions/4138957/activerecordsubclassnotfound-error-when-using-sti-in-rails
  if Rails.env.development?
    ROLES.map(&:to_s).each do |r|
      require_dependency r
    end
  end

  ROLE_TESTS = ROLES.map { |r| "#{r}?".to_sym }

  ROLE_TESTS.each_with_index do |r, i|
    define_method(r) do
      role && role.downcase.to_sym == ROLES[i]
    end
  end

  self.inheritance_column = "role"

  if Rails.env.development?
    #  default :assigned_role => 'Student', :first_name => 'a', :last_name => proc { "#{(rand*100).to_i}"}, :email => proc { "a#{(rand*10000).to_i}@a.aa" } if Rails.env == 'development'
    default :role     => 'Student', :first_name => 'Stu', :last_name => proc { "#{Student.count + 1}test" }, :email => proc { |x| "#{x.last_name}@a.aa" },
      :password => 'damnit', :password_confirmation => 'damnit'
  else
    default do |r|
      r.role = Admin.first ? 'Student' : 'Admin' if r.class == User
    end
  end

  before_validation :set_password

  def set_password
    # this leaves alone password
    if password.blank?
      self.password = self.password_confirmation = (generate_password if new_record?)
    end
  end

  def generate_password
    phrase              = Base64.encode64(Digest::SHA1.digest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}/#{email}"))[0..26]
    length              = rand(3)+6
    onset               = rand(26-length)
    @generated_password = phrase[onset..onset+length]
  end

  validates_each :discount do |record, attr_name, value|
    record.errors.add attr_name, "cannot add discount" unless value.blank? || record.created_by && record.created_by.admin?
  end

  validates_each :invoiceable do |record, attr_name, value|
    record.errors.add attr_name, "'#{record.created_by}' cannot be invoicable " unless value.blank? || record.created_by && record.created_by.admin?
  end

  validates_each :company_id do |record, attr_name, value|
    if record.role == "Teacher"
      record.errors.add :company_id, "is not allowed for teacher" unless record.company_id.nil?
    else
      if record.role == "Admin"
        record.errors.add :company_id, "is not allowed for admin" unless record.company_id.nil?
      end
    end
  end

  # probably bug in 3.1.3 uncomment if works :FIXME:
  belongs_to :created_by, :class_name => 'User'
  has_many :students, :foreign_key => :created_by_id
  belongs_to :parent, :class_name => 'User'
  has_many :children, :foreign_key => :parent_id, :class_name => 'User'

  def greet
    first_name
  end

  def name
    last_name.blank? ? "" : "#{first_name} #{last_name[0, 1]}."
  end

  def name_camel
    "#{first_name}_#{last_name[0, 1]}".camelize
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_with_email
    "#{full_name} (#{email})"
  end

  def self.extract_email(string)
    match = /\((.*)\)/.match string
    match && match.captures.first
  end

  scope :full_name_with_email, (lambda { |name|
                                  where(:email.eq => extract_email(name))
  })

  search_methods :full_name_with_email

  def abbreviated_name
    "#{first_name ? first_name[0, 1] : '?'}. #{last_name}"
  end

  def abbreviated_name_with_company
    "#{name} #{'of ' + company_name if company_name}"
  end

  def company_name
    company.name if company
  end

  ###########################################################

  scope :active, (lambda {
                    where(:active.eq => true)
  })

  scope :name_like, lambda { |a|
    #options = a.first || {}
    #names = options[:name].split /\s+/
    names      = a.split /\s+/
    first_name = names[0]
    last_name  = names[1]
    conditions = ''
    if last_name then
      conditions = ['LOWER(first_name) LIKE ? AND LOWER(last_name) LIKE ?',
                    '%' + first_name.downcase + '%', '%' + last_name.downcase + '%']
    else
      conditions = ['LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(email) LIKE ?',
                    '%' + first_name.downcase + '%', '%' + first_name.downcase + '%', '%' + first_name.downcase + '%']
    end
    scoped(:conditions => conditions)
  }

  after_create :account_created

  def account_created
    if site(:notify_when_account_created)
      if @generated_password
        Mailers::UserMailer.activation({ }, { :user => self }).deliver if Rails.env.production?
      else
        NyimJobs::DelayedUserMailer.activation({ }, { :user => self })
      end
    end
  end

end
