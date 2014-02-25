class NyimJobs::ExpireShoppingCart < NyimJobs::Base

  self.description = "expire shopping cart"

  def initialize(init={},&block)
    super(init)
    @ids              = options[:ids] || raise(ArgumentError, "no ids given")
    @transaction_code = options[:transaction_code] || raise(ArgumentError, "no transaction code given")
  end

  def perform
    expired_signups = Signup.where(:id.in => @ids, :transaction_code.eq => @transaction_code, :status.eq => 'checked_out')
    expired_signups.each &:suspend
  end

end


