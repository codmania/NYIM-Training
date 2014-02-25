Factory.define :company do |u|
  u.sequence(:name) { |n| "company_#{n}"}
end

Factory.define :admin do |u|
  u.first_name 'Admin'
  u.last_name  'Che'
  u.email "admin@nyim.com"
end

Factory.define :nyim, :parent => :company do |u|
  u.name "nyim"
  u.featured true
end

Factory.define :user do |u|
  u.first_name 'Joe'
  u.last_name  'Che'
  u.email {|a| "#{a.first_name}.#{a.last_name}@example.com".downcase }
end

Factory.define :student, :class => Student do |u|
  u.sequence(:first_name) { |n| "student_first_name_#{n}"}
  u.sequence(:last_name) { |n| "student_last_name_#{n}"}
  u.association :company, :factory => :company
  u.sequence(:email) {|n| "student#{n}@example.com" }
end

Factory.define :phone_number do |u|
  u.number '1111111111'
end

Factory.define :joe_student, :class => Student do |u|
  u.first_name 'Joe'
  u.last_name  'Che'
  u.company_name 'nyim'
  #u.association :company, :factory => :nyim
  u.email {|a| "#{a.first_name}.#{a.last_name}@example.com".downcase }
  #u.association :created_by, :factory => :admin
  u.created_by { |a| Admin.first || a.association(:admin) }
  u.after_build do |u|
    u.phone_numbers = [ Factory.build(:phone_number, :phoneable => u) ]
  end
end

Factory.define :ben_student, :class => Student do |u|
  u.first_name 'Ben'
  u.last_name  'Student'
  u.company_name 'nyim'
  #u.association :company, :factory => :nyim
  u.email {|a| "#{a.first_name}.#{a.last_name}@example.com".downcase }
  #u.association :created_by, :factory => :admin
  u.created_by { |a| Admin.first || a.association(:admin) }
  u.after_build do |u|
    u.phone_numbers = [ Factory.build(:phone_number, :phoneable => u) ]
  end
end

Factory.define :profile_ben, :class => Profile do |u|
  u.extra_subjects "Ben's extra courses"
  u.bio "Ben's bio"
end

Factory.define :teacher_ben, :class => Teacher, :parent => :user do |u|
  u.first_name 'BenTest'
  u.last_name  'Trainer'
  u.email {|a| "#{a.first_name}.#{a.last_name}@example.com".downcase }
  u.association :profile, :factory => :profile_ben
end
