class Delayed::Job
  include Process::Progress
  include Process::CompletedJobs
end

class Delayed::Worker
  include Process::FatalExceptions
end
#https://github.com/collectiveidea/delayed_job/blob/master/lib/delayed/backend/base.rb
# enqueue passes args hash to job create so job model can be enriched
# hooks can have arity and passed job object
# invoke_job does not register error on job object 
# depending on errors one can reset job.reschedule_at and max_attempts (on the process object)

::Delayed::Worker.destroy_failed_jobs = false   
::Delayed::Worker.max_attempts = 3              
::Delayed::Worker.max_run_time = 5.minutes      
::Delayed::Worker.sleep_delay = 60
::Delayed::Worker.delay_jobs = !Rails.env.test?
::Delayed::Worker.retain_completed_jobs = true