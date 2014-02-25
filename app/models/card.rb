class Card < ActiveRecord::Base
  
  attr_accessor :mandatory
  
  belongs_to :student
  belongs_to :address, :autosave => true
  
  accepts_nested_attributes_for :address, :allow_destroy => true ,  :reject_if => proc { |attrs| attrs['mandatory'] != "true" }   
 
  has_many :payments
  
  validates :student, :existence => true
  validates :address, :associated => true
  
  attr_accessor :cvv
  #validates :cvv, :presence => true, :unless => proc { |record| record.mandatory.blank? } 
  
  composed_of :credit_card, 
  :class_name => 'CreditCard' ,
  :mapping => [
                %w(card_type type),
                %w(number number),
                %w(cvv verification_value),
                %w(month month),
                %w(year year),
                %w(first_name first_name), 
                %w(last_name last_name)
  ]
  
  before_validation do |record|
    record.address.addressable ||= record.student if record.address
  end
  
  validates_each :address, :allow_blank => true do |record, attr_name, value|
    record.errors.add attr_name, "does not belong to student" unless  
    value.addressable == record.student 
  end
  
  validates :credit_card, :credit_card => { :requires_verifcation_value => true }, :on => :create
  #validates_as_credit_card :credit_card
  delegate :verification_value, :to => :credit_card
  
  def name
    credit_card.display_number
  end
  
end
