class NyimJobs::DelayedUserMailer < NyimJobs::Base

  self.description = "send mail"

  (
  class << self;
    self;
  end).instance_eval do
    [:test_email, *(Mailers::UserMailer::MAILS)].each do |method|
      define_method method do |*args|
        new(:args => encode(args), :method => method, :tag => method.to_s.humanize).launch
      end
    end
  end

  def perform
    args = decode(options[:args])
    Mailers::UserMailer.send(options[:method] || :test_email, *args).deliver
  end

  def self.encode(args=[])
    (args || []).map do |arg|
      case arg
        when Hash
          hash = Hash.new
          arg.keys.each do |key|
            value     = arg[key]
            hash[key] =
                case value
                  when ActiveRecord::Base
                    [:persist, value.class, value.id]
                  else
                    value
                end
          end
          hash
        else
          arg
      end
    end
  end

  def decode(args=[])
    (args || []).map do |arg|
      case arg
        when Hash
          hash = Hash.new
          arg.keys.each do |key|
            hash[key] =
                case value = arg[key]
                  when Array
                    persist, klass, id = value
                    if persist == :persist
                      klass.find id
                    else
                      value
                    end
                  else
                    value
                end
          end
          hash
        else
          arg
      end
    end
  end

end

