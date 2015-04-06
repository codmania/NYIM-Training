require 'spec_helper'

describe SignupsController do
  def setup
    @course = Factory.create :excel_class_in_5_days
    @student = Factory.create :joe_student
  end

  describe "sign up" do

    context "as admin" do

      before(:each) do
        login :admin
        setup
      end

      it "should sign up joe to excel" do
        sign_up
        signup = controller.resource
        check_signup(signup,:student => @student)
        session[:student].should == @student.id
      end

      it "should sign up new student joe to excel" do
        @student = Factory.build :ben_student
        sign_up
        signup = controller.resource
        @student = Student.last
        check_signup(signup,:student => @student)
        session[:student].should == @student.id
      end

      it "should sign up joe to excel, the next student should be submitted by joe" do
        @student2 = Factory.create :ben_student
        session[:student] = @student.id
        sign_up :student => @student2
        signup = controller.resource
        check_signup(signup,:student => @student2, :submitter => @student)
      end

    end

    context "as student" do
      before(:each) do
        setup
        login @student
      end

      it "should sign up" do
        sign_up :student => nil
        signup = controller.resource
        check_signup(signup, :submitter => @student)
      end

      it "should sign up another student" do
        @student2 = Factory.build :ben_student
        sign_up :student => @student2
        signup = controller.resource
        @ben_student = Student.last
        check_signup(signup, :student => @ben_student, :submitter => @student)
        session[:student].should == @ben_student.id
      end

      it "should sign up another student" do
        session[:student] = Factory.create(:student).id
        @student2 = Factory.build :ben_student
        sign_up :student => @student2
        signup = controller.resource
        @ben_student = Student.last
        check_signup(signup, :student => @ben_student)
        check_signup(signup, :submitter => @student)
      end

    end

    context "as unregistered" do
      it "should sign up" do
        @course = Factory.create :excel_class_in_5_days
        @student = Factory.build :joe_student
        sign_up
        signup = controller.resource
        @student = Student.last
        controller.current_user.should == @student
        check_signup(signup,:student => @student, :created_by => @student, :submitter => @student)
        session[:student].should == @student.id

      end
    end
  end

  describe "checkout" do
    def check_cart(cart)
      @payment = assigns[:payment]
      @payment.should be_kind_of(Payment)
      controller.resource.should == cart
      @payment.shopping_cart.should == controller.resource.to_a
      controller.resource.map(&:transaction_code).uniq.should == [@payment.order_id]
      cookies['shopping_cart'].should == @payment.order_id
    end

    context "as admin" do

      before(:each) do
        login :admin
      end

      it "should checkout from admin shopping cart" do
        @signup = Factory.create :joe_excel, :created_by => @current_user
        get :shopping_cart, :student => @current_user.id
        check_success
        check_cart([@signup.reload])
      end

      it "should checkout from student cart" do
        @signup = Factory.create :joe_excel, :created_by => @current_user
        get :shopping_cart, :student => @signup.student.id
        check_success
        check_cart([@signup.reload])
      end

    end

    context "as student" do

      before(:each) do
        @student = Factory.create :joe_student
        login @student
      end

      it "should checkout from admin shopping cart" do
        @signup = Factory.create :joe_excel, :created_by => @current_user
        get :shopping_cart, :student => @current_user.id
        check_success
        check_cart([@signup.reload])
      end

      it "should checkout from student cart" do
        @signup = Factory.create :new_excel, :created_by => @current_user
        get :shopping_cart, :student => @current_user.id
        check_success
        check_cart([@signup.reload])
      end

    end

  end

  private

  def find_email(student)
    student && !student.new_record? ? student.full_name_with_email : ""
  end

  STUDENT_REQUIRED_ATTR = ["first_name", "last_name", "email", "password", "password_confirmation", "company_name" ]

  def student_attributes(student = nil)
    a = { "mandatory" => student && "true", "phone_numbers_attributes"=>{ 0 => { "number" => student ? student.phone_numbers.first.number : "" } } }
    STUDENT_REQUIRED_ATTR.each do |attr|
      a[attr] = student ? student.send(attr) : ''
    end
    a
  end

  def sign_up(params={})
    course = params.delete(:scheduled_course) || @course
    student = params.delete(:student) || @student
    params = { "commit"=>"Create Signup", "signup"=>{"course_id"=>course.course_id, "scheduled_course_id"=>course.id, "os"=>"mac",
                                                     "student_email"=>find_email(student), "student_attributes"=>student_attributes(student && student.new_record? ? student : nil) }.merge(params) }
    post :create, params
    check_redirect
  end

  def check_signup(signup, options)
    signup.should_not be_nil
    signup.new_record?.should be_false
    defaults = { :created_by => @current_user, :scheduled_course => @course, :course => @course.course }
    options.reverse_merge(defaults).each do |key,value|
      signup.send(key).should == value
    end
  end
end

