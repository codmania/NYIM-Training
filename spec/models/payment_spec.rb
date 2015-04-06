require 'spec_helper'

describe Payment do
  include SignupSpecHelper

  describe "new payment" do
    it "should build" do
      payment = Factory.build :joe_payment
      payment.save.should be_true
      payment.reload.ip.should == '10.134.17.31'
      payment.order_id.should be_kind_of(String)
      payment.amount.should be_kind_of(Money)
      payment.submitter.should be_kind_of(User)
      payment.student.should be_kind_of(Student)
      #["CreditCardPayment", "Gift", "Cheque", "Invoice"]
      payment.payment_options.should == ["CreditCardPayment"]
    end

    it "should charge test successfully" do
      payment = Factory.create :joe_payment
      payment.charge(true,false)
      payment.success.should be_false
      payment.failed_with.should be_kind_of(String)
      payment.failed_with.length.should > 0
      payment.completed_at.should_not be_nil
      payment.should be_charged
      expect { payment.charge }.to raise_error(ArgumentError)
    end

    it "should fail test successfully" do
      payment = Factory.create :joe_payment
      payment.charge(true,true)
      payment.success.should be_true
      payment.failed_with.should be_nil
      payment.completed_at.should_not be_nil
      payment.should be_charged
      expect { payment.charge }.to raise_error(ArgumentError)
    end
  end

  describe "payment options" do

    it "should offer card, gift and cheque to admin paying for joe" do
      payment = Factory.build :admin_payment_for_joe
      #["CreditCardPayment", "Gift", "Cheque", "Invoice"]
      payment.payment_options.should == ["CreditCardPayment", "Gift", "Cheque", "Retake", "Coursehorse"]
    end

    it "should offer card, gift and cheque, invoice to admin paying for joe who is invoicable" do
      payment = Factory.build :admin_payment_for_joe, :student => Factory.build(:joe_student, :invoiceable => true)
      payment.payment_options.should == ["CreditCardPayment", "Gift", "Cheque", "Invoice", "Retake", "Coursehorse"]
    end

    it "should offer invoice for joe if inviocable" do
      payment = Factory.build :joe_payment, :student => Factory.build(:joe_student, :invoiceable => true)
      payment.payment_options.should == ["CreditCardPayment", "Invoice"]
    end

  end

end