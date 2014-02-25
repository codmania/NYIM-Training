require 'spec_helper'



describe PaymentsController do
  def setup
    @signup = Factory.create :new_excel, :created_by => @current_user, :transaction_code => code
  end

  def code
    '123'
  end

  def pay(options={})
    cart = options.delete(:cart) || [@signup]
    request.cookies['shopping_cart'] = options.delete(:cookie) || code
    post :create, :payment => { :order_id => code, :amount => cart.map(&:price!).sum.to_money }.merge(options)
    @payment = controller.resource
  end

  describe 'payment after checkout' do
    context "as student" do

      before(:each) do
        @student = Factory.create :joe_student
        login @student
        setup
      end

      it "should not pay by gift" do
        pay :type => "Gift"
        @payment.should be_kind_of(Gift)
        @payment.should_not be_valid
        @payment.should have(1).errors_on(:submitter)
      end

    end
    context "as admin" do

      before(:each) do
        login :admin
        setup
      end

      it "should pay by gift" do
        pay :type => "Gift"
        #check_success
        @payment.should be_kind_of(Gift)
      end

    end

  end

end