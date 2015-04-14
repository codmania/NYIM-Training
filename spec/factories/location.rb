FactoryGirl.define do
  factory :location do
    name "our new office"
    directions "New Square Meter"
  end
end

Factory.define :location_with_link, :parent => :location do |u|
  u.venue_link "http://google.com"
end

Factory.define :location_with_map, :parent => :location do |u|
  u.map_info "some map info"
end
