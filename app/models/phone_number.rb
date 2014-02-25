# Represents a phone number (most likely in the United States)
class PhoneNumber < ActiveRecord::Base

  default do |r|
    r.country_code = "1"
    r.number = '1111111111' if Rails.env == 'development'
  end

  belongs_to  :phoneable,  :polymorphic => true

  attr_accessor :mandatory

  before_validation :filter_number

  with_options(:allow_nil => true) do |klass|
    klass.validates_presence_of     :country_code,
    :number
    klass.validates_numericality_of :country_code, :allow_blank => true
    klass.validates_numericality_of :number, :integer_only => true, :allow_blank => true
    klass.validates_numericality_of :extension, :integer_only => true, :allow_blank => true
    klass.validates_length_of       :country_code, :in => 0..3, :allow_blank => true
    klass.validates_length_of       :number,    :is => 10, :allow_blank => true
    klass.validates_length_of       :extension,    :maximum => 10, :allow_blank => true
    klass.validates_length_of       :type,    :in => 3..10, :allow_blank => true
  end

  def to_s(format=:short) #:nodoc
    if format == :short then
      extension.blank? ? number : "#{number}/#{extension}"
    else
      human_number = ""

      human_number << "+#{country_code}-" unless country_code
      human_number << "#{number}"
      human_number << " ext. #{extension}" unless extension.blank?

    human_number
    end
  end

  def filter_number
    self.number = number.gsub(/[\+\-\(\)\ \.]/,'') if number.is_a?(String)
  end

end
