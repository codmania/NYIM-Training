require 'spec_helper'


describe Signup do
  include SignupSpecHelper
  include MailMockHelper

  context "at the time of signup" do
    it "should be valid" do
      signup = Factory.build :joe_excel
      signup.should be_valid
      signup.should be_pending
      signup.should be_attendance
      signup.should be_future
    end

    it "should check os" do
      course = Factory.build :excel_class_in_5_days, :os => 'mac'
      signup = Factory.build :joe_excel, :scheduled_course => course
      course.os.should == 'mac'

      signup.os = 'pc'
      signup.os.should == 'pc'
      signup.should have(1).errors_on(:os)

      signup.os = 'mac'
      signup.should be_valid
    end

    it "should set & check created by" do
      signup = Factory.build :joe_excel
      signup.valid?
      signup.created_by.should == signup.student
      signup.submitter.should == signup.student
    end

  end
  context "after signup" do

    it "should checkout" do
      signup = Factory.build :joe_excel
      should_allow_events! signup, :check_out, :save_for_later, :forget
      signup.should be_future
      signup.should be_not_full_or_cancelation
      signup.should_not be_booked

      signup.reserve_seats.should be_true
      signup.should be_booked
      signup.release_seats.should be_true
      signup.should_not be_booked

      signup.can_check_out?.should be_true
      signup.check_out
      signup.should be_checked_out
      signup.should be_booked

      signup.can_check_out?.should be_false
      signup.should be_valid

      signup.suspend
      signup.should be_pending
      signup.should_not be_booked

      signup.save_for_later.should be_true
      signup.should be_waiting

      signup.sign_up.should be_true
      signup.should be_pending

      signup.check_out.should be_true
      mock_mail :course_confirmation
      signup.succeed.should be_true
      signup.should be_confirmed
      signup.should be_booked

      signup.create_feedback(:scheduled_course => signup.scheduled_course)
      mock_mail :certificate
      signup.complete.should be_true
      signup.should be_awarded

    end

    it "should handle double booking" do
      signup = Factory.build :joe_excel
      signup2 = Factory.build :joe_excel
      signup.save.should be_true
      signup2.should have(1).errors_on(:scheduled_course)
      signup2.allow_double_booking = true
      signup2.should have(1).errors_on(:scheduled_course)

      signup.save_for_later.should be_true
      signup.should_not be_full

      signup.scheduled_course.close!.should be_true
      signup.should be_full
      signup.save.should be_true

      signup2 = Factory.build :joe_excel
      signup2.should have(1).errors_on(:scheduled_course)

      course = signup.scheduled_course
      course.add_seats!.should be_true
      signup2 = Factory.build :joe_excel
      signup2.save.should be_true
      expect { signup.reload }.to raise_error(ActiveRecord::RecordNotFound)

      signup3 = Factory.build :joe_new_excel
      #signup3.course_can_be_booked?.should be_false
      signup3.should have(1).errors_on(:scheduled_course)
      signup3.allow_double_booking = true
      signup3.save.should be_true

      signup2.save_for_later.should be_true
      signup2.sign_up.should be_false
      signup2.allow_double_booking = true
      signup2.sign_up.should be_true

    end
  end
  describe "cancelations:" do

    it "should cancel free in 5 days" do
      signup = sign_up_with :joe_new_excel
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full

      signup.cancel.should be_true
      cancelation = signup.sisters.cancelation.first
      cancelation.should be_nil
      signup.should be_released
      signup.should_not be_full
    end

    it "should cancel in 3 days for a fee" do

      signup = sign_up_with :joe_new_excel_in_3_days
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full
      mock_mail :course_cancelation, :course_cancelation_admin
      signup.cancel.should be_true
      signup.reload.should be_full

      cancelation = signup.sisters.cancelation.first
      cancelation.should_not be_nil
      cancelation.check_out.should be_true
      cancelation.calculate_price.should == Money.new(site(:refund_fee||0)*100)
      cancelation.discount_description.should == 'late cancelation fee'
      signup.reload.should be_full
      cancelation.succeed.should be_true

      signup.reload.should be_released
      signup.should_not be_full

    end

    it "should not allow cancel if too late" do
      signup = sign_up_with :joe_new_excel_in_1_day
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full
      signup.can_cancel?.should be_false
      signup.reload.should be_full

      cancelation = signup.sisters.cancelation.first
      cancelation.should be_nil
      signup.reload.should be_full
    end

    it "should reconfirm" do
      signup = sign_up_with :joe_new_excel_in_3_days
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full
      signup.cancel.should be_true
      signup.reload.should be_full

      cancelation = signup.sisters.cancelation.first
      cancelation.should_not be_nil
      cancelation.calculate_price.should == Money.new((site(:refund_fee)||0)*100)

      signup.reconfirm.should be_true
      cancelation = signup.sisters.cancelation.first
      cancelation.should be_nil
      signup.reload.should be_full
    end

    it "should reconfirm if cancelation revoked" do
      signup = sign_up_with :joe_new_excel_in_3_days
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full
      signup.cancel.should be_true
      signup.reload.should be_full

      cancelation = signup.sisters.cancelation.first
      cancelation.should_not be_nil
      cancelation.calculate_price.should == Money.new((site(:refund_fee)||0)*100)
      cancelation.can_save_for_later?.should be_false
      cancelation.forget.should be_true

      #pending? && cancelation? && parent && parent.reconfirm
      signup.reload.should be_confirmed
      cancelation = signup.sisters.cancelation.first
      cancelation.should be_nil
      signup.reload.should be_full
    end

  end

  describe "rescheduling" do
    it "should reschedule free in 5 days" do
      signup = sign_up_with :joe_new_excel
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full

      course = Factory.create :excel_class_in_5_days
      signup.rescheduled_course_id = course.id
      course.should_not be_booked

      signup.cancel.should be_true
      cancelation = signup.sisters.cancelation.first
      cancelation.should be_nil

      retake = signup.cousins.attendance.first
      retake.should_not be_nil
      retake.scheduled_course.should == course
      retake.should be_confirmed
      course.reload.should be_booked

      signup.reload.should be_released
      signup.should_not be_full

    end

    it "should reschedule in 3 days" do
      signup = sign_up_with :joe_new_excel_in_3_days
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full

      course = Factory.create :excel_class_in_5_days
      signup.rescheduled_course_id = course.id
      course.should_not be_booked

      signup.cancel.should be_true
      cancelation = signup.sisters.cancelation.first
      cancelation.should be_nil

      retake = signup.cousins.attendance.first
      retake.should_not be_nil
      retake.scheduled_course.should == course
      retake.should be_pending
      course.reload.should_not be_booked
      signup.reload.should be_full

      retake.check_out.should be_true
      retake.calculate_price.should == Money.new((site(:retake_fee)||0)*100)
      signup.reload.should be_full
      retake.succeed.should be_true

      retake.should be_confirmed
      course.reload.should be_booked

      signup.reload.should be_released
      signup.should_not be_full

    end

    it "should allow reconfirm cancelation on retake" do
      signup = sign_up_with :joe_new_excel_in_3_days
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full

      course = Factory.create :excel_class_in_5_days
      signup.rescheduled_course_id = course.id
      course.should_not be_booked

      signup.cancel.should be_true

      retake = signup.cousins.attendance.first
      retake.should_not be_nil

      signup.reconfirm.should be_true
      retake = signup.cousins.attendance.first
      retake.should be_nil
      signup.reload.should be_full
    end

    it "should reconfirm if retake revoked" do
      signup = sign_up_with :joe_new_excel_in_3_days
      signup.scheduled_course.close!.should be_true
      signup.reload.should be_full

      course = Factory.create :excel_class_in_5_days
      signup.rescheduled_course_id = course.id
      course.should_not be_booked

      signup.cancel.should be_true

      retake = signup.cousins.attendance.first
      retake.should_not be_nil

      retake.save_for_later.should be_true
      retake.sign_up.should be_true

      retake.forget.should be_true

      signup.reload.should be_confirmed
      retake = signup.cousins.attendance.first
      retake.should be_nil
      signup.reload.should be_full
    end

  end

  describe "pricing and discount"  do

    it "should set no discount" do
      signup = sign_up_with :joe_new_excel
      signup.calculate_price.should == signup.scheduled_course.price
    end

    it "should set returning customer discount" do
      signup = sign_up_with :joe_new_excel
      signup = sign_up_with :joe_new_excel
      signup.student.should be_returning_customer
      signup.calculate_price.should == signup.discount_price(site(:returning_customer_discount))
    end

    it "should set promotional discount" do
      signup = sign_up_with :joe_new_promotional
      signup.should be_promotional
      signup.calculate_price.should == signup.discount_price(signup.scheduled_course.promotional_discount)
    end

    it "should not set expired promotional discount" do
      signup = sign_up_with :joe_new_expired_promotional
      signup.calculate_price.should == signup.scheduled_course.price
    end

    it "should set company discount" do
      signup = sign_up_with :joe_new_excel
      student = signup.student
      student.update_attribute :discount, 36
      signup.calculate_price.should == signup.discount_price(36)
    end

    it "should choose highest discount" do
      signup = sign_up_with :joe_new_excel
      student = signup.student
      student.update_attribute :discount, 36
      signup = sign_up_with :joe_new_promotional
      signup.calculate_price.should == signup.discount_price(36)
      student.update_attribute :discount, 30
      signup = sign_up_with :joe_new_promotional
      signup.calculate_price.should == signup.discount_price(signup.scheduled_course.promotional_discount)
    end
  end

end
