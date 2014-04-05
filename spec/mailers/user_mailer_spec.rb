require 'spec_helper'
require 'spec_helpers/asset_spec_helper'
#require File.expand_path("../../../app/mailers/user_mailer", __FILE__)

module MailerSpecHelper
  def check_email(email, values)
    values.each do |attr, value|
      email.send(attr).should == value
    end
  end

  def check_body(email, *matchers)
    matchers.each do |m|
      email.body.encoded.should match m
    end
  end
end

describe Mailers::UserMailer do
  include MailerSpecHelper
  include AssetSpecHelper
  context 'existing assets with correct contents' do

    before :each do
      @to     = 'viktor.tron@googlemail.com'
      student = Factory.create :student, :email => @to
      course  = Factory.create :excel_class_in_5_days
      signup  = Factory.create :joe_new_excel
      payment = Payment.new
      payment.save :validate => false
      signup.course  = signup.scheduled_course.course
      signup.payment = payment
      @options       = { }
      @assigns       = { :user => student, :student => student, :signup => signup, :course => course, :payment => payment }
    end

    Mailers::UserMailer::MAILS.each do |name|

      it "should create #{name} (multipart mail with subject)" do
        email   = Mailers::UserMailer.send(name, @options, @assigns)
        subject = Mailers::UserMailer.subject(name, @assigns)
        check_email email, :subject => subject, :to => [@to]
        email.deliver
        ActionMailer::Base.deliveries.should_not be_empty
      end
    end
  end

end
