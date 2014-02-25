Factory.define :course_group do |u|
  u.name 'Hei'
  u.short_name 'hello'
end

Factory.define :office_group, :parent => :course_group do |u|
  u.name 'office'
end

Factory.define :course do |u|
  u.name 'hello'
  u.short_name 'hello'
end

Factory.define :excel, :parent => :course do |u|
  u.name 'Excel'
  u.association :course_group, :factory => :office_group
  u.price 135
  u.os 'mac'
end

Factory.define :scheduled_session_in_5_days, :class => ScheduledSession do |u|
  u.starts_at { |a| 5.days.from_now }
  u.duration 60
end

Factory.define :scheduled_session_in_3_days, :class => ScheduledSession do |u|
  u.starts_at { |a| 3.days.from_now }
  u.duration 60
end

Factory.define :scheduled_session_in_1_day, :class => ScheduledSession do |u|
  u.starts_at { |a| 1.days.from_now }
  u.duration 60
end

Factory.define :union_square, :class => Location do |u|
  u.name 'Union Square'
  u.directions 'directions to Union Sq'
end

Factory.define :scheduled_course, :class => ScheduledCourse do |u|
  u.after_build do |u|
    u.scheduled_sessions = [ Factory.build(:scheduled_session_in_5_days, :scheduled_course => u) ]
    u.starts_at = u.scheduled_sessions.first.starts_at
  end
  u.after_create do |u|
    u.scheduled_sessions.each &:save!
  end
  #u.association :location, :factory => :union_square
  u.location { |a| Location.first || a.association(:union_square) }
  #u.association :teacher, :factory => :teacher_ben
  u.teacher { |a| Teacher.first || a.association(:teacher_ben) }
end

Factory.define :scheduled_course_in_5_days, :parent => :scheduled_course do |u|
  u.after_build do |u|
    u.scheduled_sessions = [ Factory.build(:scheduled_session_in_5_days, :scheduled_course => u) ]
    u.starts_at = u.scheduled_sessions.first.starts_at
  end
end

Factory.define :scheduled_course_in_3_days, :parent => :scheduled_course do |u|
  u.after_build do |u|
    u.scheduled_sessions = [ Factory.build(:scheduled_session_in_3_days, :scheduled_course => u) ]
    u.starts_at = u.scheduled_sessions.first.starts_at
  end
end

Factory.define :scheduled_course_in_1_day, :parent => :scheduled_course do |u|
  u.after_build do |u|
    u.scheduled_sessions = [ Factory.build(:scheduled_session_in_1_day, :scheduled_course => u) ]
    u.starts_at = u.scheduled_sessions.first.starts_at
  end
end

Factory.define :excel_class_in_5_days, :parent => :scheduled_course_in_5_days do |u|
#u.association :course, :factory => :excel
  u.course { |a| Course.find_by_name('Excel') || a.association(:excel) }
end

Factory.define :excel_class_in_3_days, :parent => :scheduled_course_in_3_days do |u|
#u.association :course, :factory => :excel
  u.course { |a| Course.find_by_name('Excel') || a.association(:excel) }
end

Factory.define :excel_class_in_1_day, :parent => :scheduled_course_in_1_day do |u|
#u.association :course, :factory => :excel
  u.course { |a| Course.find_by_name('Excel') || a.association(:excel) }
end

Factory.define :promotional, :parent => :excel_class_in_5_days  do |u|
  u.promotional_discount 34
  u.promotion_expires_at { 2.months.from_now }
end

Factory.define :expired_promotional, :parent => :excel_class_in_5_days  do |u|
  u.promotional_discount 34
  u.promotion_expires_at { 1.minute.ago }
end
