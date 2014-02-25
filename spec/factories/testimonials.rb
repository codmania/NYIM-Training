# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :testimonial do
      teacher nil
      course nil
      text "MyText"
      name "MyString"
    end
end