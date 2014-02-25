Factory.define :signup do
  
end

Factory.define :any_excel, :parent => :signup do |u|
  u.association :student, :factory => :student
end

Factory.define :same_excel, :parent => :any_excel do |u|
  u.scheduled_course { |a| ScheduledCourse.by_course_name('Excel').future.first || a.association(:excel_class_in_5_days) }
end

Factory.define :new_excel, :parent => :any_excel do |u|
  u.association :scheduled_course, :factory => :excel_class_in_5_days
end

Factory.define :new_promotional, :parent => :any_excel do |u|
  u.association :scheduled_course, :factory => :promotional
end

Factory.define :new_expired_promotional, :parent => :any_excel do |u|
  u.association :scheduled_course, :factory => :expired_promotional
end

Factory.define :new_excel_in_3_days, :parent => :any_excel do |u|
  u.association :scheduled_course, :factory => :excel_class_in_3_days
end

Factory.define :new_excel_in_1_day, :parent => :any_excel do |u|
  u.association :scheduled_course, :factory => :excel_class_in_1_day
end

Factory.define :joe_excel,  :parent => :same_excel do |u|
  u.student { |a| Student.find_by_email('joe.che@example.com') || a.association(:joe_student) }
end

Factory.define :joe_new_promotional,  :parent => :new_promotional do |u|
  u.student { |a| Student.find_by_email('joe.che@example.com') || a.association(:joe_student) }
end

Factory.define :joe_new_expired_promotional,  :parent => :new_expired_promotional do |u|
  u.student { |a| Student.find_by_email('joe.che@example.com') || a.association(:joe_student) }
end

Factory.define :joe_new_excel,  :parent => :new_excel do |u|
  u.student { |a| Student.find_by_email('joe.che@example.com') || a.association(:joe_student) }
end

Factory.define :joe_new_excel_in_3_days,  :parent => :new_excel_in_3_days do |u|
  u.student { |a| Student.find_by_email('joe.che@example.com') || a.association(:joe_student) }
end

Factory.define :joe_new_excel_in_1_day,  :parent => :new_excel_in_1_day do |u|
  u.student { |a| Student.find_by_email('joe.che@example.com') || a.association(:joe_student) }
end


