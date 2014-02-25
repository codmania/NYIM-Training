module Process::CompletedJobs
  #https://github.com/collectiveidea/delayed_job/blob/master/lib/delayed/worker.rb
  # if completed jobs are not destroyed
  # we also have to make sure completed jobs are not rerun
  # both accomplished via intercepting the success hook and setting completed_at to current db time 
  # this module is agnostic as to whether completed_at is a db column 
  
  #scope :ready_to_run, lambda {|worker_name, max_run_time|
  #  where(['(run_at <= ? AND (locked_at IS NULL OR locked_at < ?) OR locked_by = ?) AND failed_at IS NULL', db_time_now, db_time_now - max_run_time, worker_name])
  #}
  
  def self.included(base)
    base.class_eval do
      
      attr_accessor *(['completed_at'] - (column_names rescue []))
      
      def hook_with_completion(name, *args)
        
        if name == :success && ::Delayed::Worker.retain_completed_jobs
          self.completed_at = @_completed_at = self.class.db_time_now
          # this line is a hack, see the ready hook
          # ideal solution would be to set a further scope to select jobs
          self.run_at = 100.years.since(self.class.db_time_now) 
          unlock
        end
        hook_without_completion(name, *args)
        save!
      end
      alias_method_chain :hook, :completion
      
      def destroy_with_completion
        ::Delayed::Worker.retain_completed_jobs && @_completed_at || destroy_without_completion
      end
      alias_method_chain :destroy, :completion
    end
    
  end
  
  class ::Delayed::Worker
    cattr_accessor :retain_completed_jobs
    self.retain_completed_jobs = false
  end
  
  
end