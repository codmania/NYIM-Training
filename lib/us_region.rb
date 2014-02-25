class UsRegion

  #   Region['US-CA']   # => #<Region id: 840005, code: "US-CA", country_id: 840, group: nil, name: "California", abbreviation: "CA">
  REGIONS = [      { :id => 840001, :name => "Alabama", :abbreviation => 'AL' },
    { :id => 840002, :name => "Alaska", :abbreviation => 'AK' },
    { :id => 840003, :name => "Arizona", :abbreviation => 'AZ' },
    { :id => 840004, :name => "Arkansas", :abbreviation => 'AR' },
    { :id => 840005, :name => "California", :abbreviation => 'CA' },
    { :id => 840006, :name => "Colorado", :abbreviation => 'CO' },
    { :id => 840007, :name => "Connecticut", :abbreviation => 'CT' },
    { :id => 840008, :name => "Delaware", :abbreviation => 'DE' },
    { :id => 840009, :name => "Florida", :abbreviation => 'FL' },
    { :id => 840010, :name => "Georgia", :abbreviation => 'GA' },
    { :id => 840011, :name => "Hawaii", :abbreviation => 'HI' },
    { :id => 840012, :name => "Idaho", :abbreviation => 'ID' },
    { :id => 840013, :name => "Illinois", :abbreviation => 'IL' },
    { :id => 840014, :name => "Indiana", :abbreviation => 'IN' },
    { :id => 840015, :name => "Iowa", :abbreviation => 'IA' },
    { :id => 840016, :name => "Kansas", :abbreviation => 'KS' },
    { :id => 840017, :name => "Kentucky", :abbreviation => 'KY' },
    { :id => 840018, :name => "Louisiana", :abbreviation => 'LA' },
    { :id => 840019, :name => "Maine", :abbreviation => 'ME' },
    { :id => 840020, :name => "Maryland", :abbreviation => 'MD' },
    { :id => 840021, :name => "Massachusetts", :abbreviation => 'MA' },
    { :id => 840022, :name => "Michigan", :abbreviation => 'MI' },
    { :id => 840023, :name => "Minnesota", :abbreviation => 'MN' },
    { :id => 840024, :name => "Mississippi", :abbreviation => 'MS' },
    { :id => 840025, :name => "Missouri", :abbreviation => 'MO' },
    { :id => 840026, :name => "Montana", :abbreviation => 'MT' },
    { :id => 840027, :name => "Nebraska", :abbreviation => 'NE' },
    { :id => 840028, :name => "Nevada", :abbreviation => 'NV' },
    { :id => 840029, :name => "New Hampshire", :abbreviation => 'NH' },
    { :id => 840030, :name => "New Jersey", :abbreviation => 'NJ' },
    { :id => 840031, :name => "New Mexico", :abbreviation => 'NM' },
    { :id => 840032, :name => "New York", :abbreviation => 'NY' },
    { :id => 840033, :name => "North Carolina", :abbreviation => 'NC' },
    { :id => 840034, :name => "North Dakota", :abbreviation => 'ND' },
    { :id => 840035, :name => "Ohio", :abbreviation => 'OH' },
    { :id => 840036, :name => "Oklahoma", :abbreviation => 'OK' },
    { :id => 840037, :name => "Oregon", :abbreviation => 'OR' },
    { :id => 840038, :name => "Pennsylvania", :abbreviation => 'PA' },
    { :id => 840039, :name => "Rhode Island", :abbreviation => 'RI' },
    { :id => 840040, :name => "South Carolina", :abbreviation => 'SC' },
    { :id => 840041, :name => "South Dakota", :abbreviation => 'SD' },
    { :id => 840042, :name => "Tennessee", :abbreviation => 'TN' },
    { :id => 840043, :name => "Texas", :abbreviation => 'TX' },
    { :id => 840044, :name => "Utah", :abbreviation => 'UT' },
    { :id => 840045, :name => "Vermont", :abbreviation => 'VT' },
    { :id => 840046, :name => "Virginia", :abbreviation => 'VA' },
    { :id => 840047, :name => "Washington", :abbreviation => 'WA' },
    { :id => 840048, :name => "West Virginia", :abbreviation => 'WV' },
    { :id => 840049, :name => "Wisconsin", :abbreviation => 'WI' },
    { :id => 840050, :name => "Wyoming", :abbreviation => 'WY' },
    { :id => 840051, :name => "District of Columbia", :abbreviation => 'DC' },
    { :id => 840052, :name => "American Samoa", :abbreviation => 'AS' },
    { :id => 840053, :name => "Guam", :abbreviation => 'GU' },
    { :id => 840054, :name => "Northern Mariana Islands", :abbreviation => 'MP' },
    { :id => 840055, :name => "Puerto Rico", :abbreviation => 'PR' },
    { :id => 840056, :name => "United States Minor Outlying Islands", :abbreviation => 'UM' },
    { :id => 840057, :name => "Virgin Islands", :abbreviation => 'VI' }
  ]

  REGIONS_BY_ID = {}
  REGIONS.map { |r| REGIONS_BY_ID[r[:id]] = r }

  def self.dropdown
    REGIONS.map { |r| [r[:name],r[:id]] }
  end

  def initialize(id)
    @region = REGIONS_BY_ID[id]
  end
  
  [:id, :name, :abbreviation].each do |method|
    define_method method do
      @region[method]
    end
  end

  
end
