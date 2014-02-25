def get_joe
  @joe = Student.find_by_email('joe.che@example.com') || Factory.create(:joe_student)
end

def get_admin
  @admin = Admin.first || Factory.create(:admin)
end

Factory.define :payment, :class => Payment do |u|
  u.ip '10.134.17.31'
  u.transaction_code 'test'
  u.after_build { |r| r.set_amount }
end

Factory.define :joe_payment, :parent => :payment do |u|
  u.student { get_joe }
end

Factory.define :admin_payment_for_joe, :parent => :payment do |u|
  u.student { get_joe }
  u.submitter { get_admin }
end