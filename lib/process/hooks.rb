module Process::Hooks
  
  def self.included(base)
    base.class_eval do
      cattr_accessor :register, :fatal_exceptions
      include HookInstanceMethods
    end
  end  
  
  
  module HookInstanceMethods
    
    def enqueue(job)
      self.class.register.each do |attr|
        val = send(attr)
        job.send "#{attr}=", val unless val.nil?
      end
    end
    
      def before(job)
      job.started_at = job.class.db_time_now
      #job.description = "started at #{job.started_at}"
      job.save!
    end
    
    def success(job)
      return unless job.completed_at && job.started_at
      job.runtime = job.completed_at - job.started_at 
    end
    
    def error(job,exc)
      job.failed_with = exc.message
      case exc
        when self.class.fatal_exceptions then job.fatal = true
      end
      job.last_error_at = job.class.db_time_now
      job.save!
    end
    
    def failure(job)
      # this is debatable
      job.fatal = true
    end
    
  end
  
end