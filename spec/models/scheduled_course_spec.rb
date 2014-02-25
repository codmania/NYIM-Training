require 'spec_helper'

describe ScheduledCourse do

  describe "validity scheduled courses" do

    it "should have location" do
      course = Factory.build :excel_class_in_5_days
      course.valid?
      course.should be_valid
    end

    it "should have location" do
      course = Factory.build :excel_class_in_5_days, :location => nil, :teacher => nil
      course.should have(1).errors_on(:location)
      course.should have(1).errors_on(:teacher)
    end

    it "should have default number of seats enforced on creation" do
      course = Factory.build :excel_class_in_5_days
      course.seats.should == Site.site(:default_course_seats)
      course.seats_available = course.seats + 1
      course.should be_valid
      course.seats_available.should == course.seats
    end

    it "should fall back to course price" do
      course = Factory.build :excel_class_in_5_days
      course.price.should == course.course.price
    end

    it "should allow specific price" do
      course = Factory.build :excel_class_in_5_days, :price => 100
      course.should be_valid
      course.price.should == Money.new(10000)
    end

    it "should fall back to course os" do
      course = Factory.build :excel_class_in_5_days
      course.os.should == course.course.os
    end

    it "should fall back to course os" do
      course = Factory.build :excel_class_in_5_days
      course.os.should == course.course.os
    end

    it "should allow specific os" do
      course = Factory.build :excel_class_in_5_days, :os => 'mac'
      course.should be_valid
      course.os.should == 'mac'
    end

    it "should allow specific os unless course restricts" do
      course = Factory.build :excel_class_in_5_days, :os => 'pc'
      course.should have(1).errors_on(:os)
    end

    it "should set hours and times" do
      course = Factory.build :excel_class_in_5_days
      course.should be_valid
      course.hours.should == 1
      course.starts_at.should == course.scheduled_sessions.first.starts_at
      course.ends_at.should == course.scheduled_sessions.last.ends_at
    end

    it "should show correct predicates" do
      course = Factory.build :excel_class_in_5_days
      course.should be_valid
      course.full?.should == false
      course.upcoming?.should == true
      course.future?.should == true
      course.past?.should == false
      course.running?.should == false
      course.active.should == true
      course.recent_vacancy?.should == false
      course.recently_became_full?.should == false
    end

  end

  describe "reservations" do
    it "should show reserve" do
      course = Factory.build :excel_class_in_5_days
      course.should be_valid
      
      course.booked?.should == false
      course.reserve.should == true
      course.seats_available.should == course.seats - 1
      course.booked?.should == true
      course.recently_became_full?.should == false

      course.close.should == true
      course.seats_available.should == 0
      course.seats.should == 1
      course.recently_became_full?.should == true

      course.unreserve.should == true
      course.seats_available.should == 1
      course.recent_vacancy?.should == true
      course.booked?.should == false
      course.full?.should == false

      course.reserve.should == true
      course.seats_available.should == 0
      course.recently_became_full?.should == true
      course.remove_seats.should == false

      course.add_seats.should == true
      course.seats_available.should == 1
      course.recent_vacancy?.should == true
    end
  end

end

