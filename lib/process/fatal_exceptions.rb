module Process::FatalExceptions
  #https://github.com/collectiveidea/delayed_job/blob/master/lib/delayed/worker.rb
  # if fatal is set on the job, the job is permanently removed from the queue 
  # same behaviour as if max attempts had been reached
  # fatal can be set e.g., by an error hook on the process object
  # this module is agnostic whether fatal is a db column 
  
  def self.included(base)
    base.class_eval do
      
      attr_accessor *(['fatal'] - (column_names rescue []))
      
      def reschedule_with_fatal_exceptions(job, *args)
        if job.fatal 
          failed(job)
        else
          reschedule_without_fatal_exceptions(job, *args)
        end
        alias_method_chain :reschedule, :fatal_exceptions
        
      end
    end
    
  end
  
end
