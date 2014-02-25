# Represents a generic mailing address. Addresses are expected to consist of
# the following fields:
# * +addressable+ - The record that owns the address
# * +street_1+ - The first line of the street address
# * +city+ - The name of the city
# * +postal_code+ - A value uniquely identifying the area in the city
# * +region+ - Either a known region or a custom value for countries that have no list of regions available
# * +country+ - The country, which may be implied by the region
# 
# The following fields are optional:
# * +street_2+ - The second line of the street address
# 
# There is no attempt to validate open-ended fields since the context in which
# the addresses will be used is unknown
class Address < ActiveRecord::Base
  ##############################
  # TV added 
  default :city=>"New York City", :region_id => 840032, :country_id => 840
  
  #error_names :addressable_id => false, :addressable_type => false 
  ##################################
  
  belongs_to :addressable, :polymorphic => true
  #belongs_to :region
  #belongs_to :country
  
  
  attr_accessor :mandatory
  #attr_accessible :mandatory
  ###############
  # postal code validation for US
  validates_format_of   :postal_code,
  :if => proc { |a| a.country_id == 840 },
  :with => /^[0-9]{5}$/,
  :allow_blank => true
  
  validates_presence_of :street_1, :city,
  :postal_code#, :country_id
  validates_presence_of :region_id#, :if => :known_region_required?
  #validates_presence_of :custom_region, :if => :custom_region_required?
  
  #attr_accessible :all
  #attr_accessible :street_1, :street_2, :city, :postal_code, :region_id, :custom_region, :country
  
  #before_validation :ensure_exclusive_references 
  #before_validation :set_region_attributes
  
  # Gets the name of the region that this address is for (whether it is a
  # custom or known region in the database)
  def region
    #custom_region || region && region.name
    UsRegion.new(region_id)
  end
  
  def country_name
    'United States'
  end
  
  
  
  # Gets a representation of the address on a single line.
  # 
  # For example,
  # 
  #   address = Address.new
  #   address.single_line     # => ""
  #   
  #   address.street_1 = "1600 Amphitheatre Parkey"
  #   address.single_line     # => "1600 Amphitheatre Parkway"
  #   
  #   address.street_2 = "Suite 100"
  #   address.single_line     # => "1600 Amphitheatre Parkway, Suite 100"
  #   
  #   address.city = "Mountain View"
  #   address.single_line     # => "1600 Amphitheatre Parkway, Suite 100, Mountain View"
  #   
  #   address.region = Region['US-CA']
  #   address.single_line     # => "1600 Amphitheatre Parkway, Suite 100, Mountain View, California, United States"
  #   
  #   address.postal_code = '94043'
  #   address.single_line     # => "1600 Amphitheatre Parkway, Suite 100, Mountain View, California  94043, United States"
  def single_line
    multi_line.join(', ')
  end
  # aliases
  alias_method :name, :single_line
  
  def to_s(format=:short,sep="\n")
   (format == :short) ? single_line : multi_line.join(sep)
  end
  
  
  # Gets a representation of the address on multiple lines.
  # 
  # For example,
  # 
  #   address = Address.new
  #   address.multi_line      # => []
  #   
  #   address.street_1 = "1600 Amphitheatre Parkey"
  #   address.multi_line      # => ["1600 Amphitheatre Parkey"]
  #   
  #   address.street_2 = "Suite 100"
  #   address.multi_line      # => ["1600 Amphitheatre Parkey", "Suite 100"]
  #   
  #   address.city = "Mountain View"
  #   address.multi_line      # => ["1600 Amphitheatre Parkey", "Suit 100", "Mountain View"]
  #   
  #   address.region = Region['US-CA']
  #   address.multi_line      # => ["1600 Amphitheatre Parkey", "Suit 100", "Mountain View, California", "United States"]
  #   
  #   address.postal_code = '94043'
  #   address.multi_line      # => ["1600 Amphitheatre Parkey", "Suit 100", "Mountain View, California  94043", "United States"]
  def multi_line
    lines = []
    lines << street_1 if street_1?
    lines << street_2 if street_2?
    
    line = ''
    line << city if city?
    if region && region.name
      line << ', ' unless line.blank?
      line << region.name
    end
    if postal_code?
      line << '  ' unless line.blank?
      line << postal_code
    end
    lines << line unless line.blank?
    
    lines << country_name 
    lines
  end
  
  def info 
    [['address', to_s(:long)]]
  end  
  
  
  
end
