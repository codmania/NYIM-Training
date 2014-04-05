class Location < ActiveRecord::Base

  hidden_attribute_match = /^(location_id)$/
  all_fields_blank = proc { |attrs| attrs.all? { |a,v| hidden_attribute_match.match(a) || v.blank? } }

  has_one :address, :as => :addressable, :dependent => :destroy, :autosave => true
  accepts_nested_attributes_for :address, :allow_destroy => false, :reject_if => all_fields_blank

  has_many :scheduled_courses, :order => 'starts_at DESC'

  validates_presence_of :name, :directions, :allow_nil => false

  def to_s(format=:short)
    (address.nil? || format == :short) ? name : address.multi_line.unshift(name).join("\n")
  end

  def title
    name
  end

  has_asset :directions

  scope :active, -> { where(:active.eq => true) }

end
