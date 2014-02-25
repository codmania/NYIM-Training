require 'openssl'

#http://activemerchant.rubyforge.org/classes/ActiveMerchant/Billing/LinkpointGateway.html
#www.linkpointcentral.com/lpc/docs/Help/APIHelp/lpintguide.htm

class CreditCardPayment < Payment

  attr_accessor :test_response
  #LIVE Production mode
  #GOOD Approved response in test mode
  #DECLINE Declined response in test mode
  #DUPLICATE

  def self.test_responses
    ['LIVE', 'GOOD', 'DECLINE', 'DUPLICATE']
  end

  validates :card, :existence => true, :allow_nil => true
  validates_each :card, :allow_blank => true do |record, attr, value|
    record.errors.add attr_name, "does not belong to student" unless value.student == record.student || record.submitter.is_a?(Admin) || value.student == record.submitter
  end

  def authorized?(r=nil)
    r ||= self
    r.submitter.is_a?(Student) || r.student.is_a?(Student)
  end

  delegate :address, :to => :card
  before_validation :credit_card, :set_student

  # this is called before validation, crucially sets cvv as well as store on card
  def credit_card
    @card ||= card.credit_card(store, cvv) if card && store
    logger.debug "credit card: #{@card.inspect}"
    logger.debug "card: #{card.inspect}"
    @card
  end

  def set_student
    card.student = student || submitter if card
  end

  after_validation :set_errors

  def set_errors
    self.failed_with = payment_errors.to_a.to_sentence
  end

  class_attribute :linkpoint_gateway, :instance_reader => false, :instance_writer => false

  # supported cardtypes acts as a class method
  def self.supported_cardtypes
    ActiveMerchant::Billing::LinkpointGateway.supported_cardtypes
  end

  def self.live?
    site(:linkpoint_live_mode)
  end

  def self.clear
    self.linkpoint_gateway = nil
  end

  # site update should trigger reinitialization of gateway
  def self.gateway(options = { })
    force = options[:force]
    return linkpoint_gateway unless linkpoint_gateway.blank? || force
    # we are over-super-hyper cautious here.
    # we NEVER go LIVE in development/test mode
    live = live?
    logger.info "[CARD PAYMENT] initialize linkpoint payment gateway in #{live ? 'live' : 'test'} mode"
    login    = live ? site(:linkpoint_store_number) : site(:linkpoint_test_store_number)
    pem_file = live ? site(:linkpoint_certificate) : site(:linkpoint_test_certificate)
    pem      = File.read pem_file
    options.update(:login => login, :pem => pem, :test => !live)
    self.linkpoint_gateway = ActiveMerchant::Billing::LinkpointGateway.new(options)
  end

  ##################################
  # payment gateway and options setup

  def gateway(*args)
    begin
      @gateway ||= self.class.gateway(*args)
    rescue Exception => x
      payment_errors[:gateway]        = x.message
      public_payment_errors[:gateway] = 'failed to initialize'
    end
  end

  def options
    begin
      order_code = "#{order_id}-#{attempts}"
      @options   ||= {
          :address1          => address.street_1,
          :address2          => address.street_2,
          :city              => address.city,
          :zip               => address.postal_code,
          :state             => address.region.abbreviation,
          #:ponumber          => order_code,
          :order_id          => order_code,
          #:result            => live? ? 'LIVE' : test_response,
          :transactionorigin => 'ECI',
          :ip                => ip
      }
    rescue Exception => x
      payment_errors[:options]        = x.message
      public_payment_errors[:options] = 'failed to initialize'
    end
  end

  def live?
    self.class.live?
  end

  ###################################################
  # payment methods

  def charge!()
    if test_response && !live?
      @gateway = nil
      gateway(:force => true, :result => test_response)
    end
    begin
      response = authorize
      logger.debug "[CARD PAYMENT][AUTHORIZE]#{response.inspect}"
      if response.success?
        response = capture
        logger.debug "[CARD PAYMENT][CAPTURE]#{response.inspect}"
        if response.success?
          return true
        else
          payment_errors[:capture]        = response.inspect
          public_payment_errors[:capture] = response.params['error']
        end
      else
        payment_errors[:authorize]        = response.inspect
        public_payment_errors[:authorize] = response.params['error']
      end
    rescue ActiveMerchant::ConnectionError => m
      payment_errors[:connection]        = m.to_s
      public_payment_errors[:connection] = "failed"
    rescue REXML::ParseException => m
      payment_errors[:message]        = m.to_s
      public_payment_errors[:message] = "corrupted"
    end
    false
  end

#Airbrake.notify(
#    :error_class   => "Payment Error",
#    :error_message => "Payment Error: #{response.params['error']}",
#    :parameters    => { :payment => self }

#Support for Money objects is deprecated and will be removed from a future release of ActiveMerchant. Please use an Integer value in cents
  [:purchase, :recurring, :authorize].each do |method|
    define_method method do
      # :FIXME
      logger.debug "[CARD PAYMENT][OPTIONS] #{options.inspect}"
      gateway.send method, amount, credit_card, options if gateway && options
    end
  end

  [:credit, :capture].each do |method|
    define_method method do
      logger.debug "[CARD PAYMENT][OPTIONS] #{options.inspect}"
      gateway.send method, amount, options[:order_id], options if gateway && options
    end
  end

  def void
    gateway.void(order_id)
  end

end