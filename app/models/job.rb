class Job < Delayed::Job
  
  belongs_to :user
  
  def status
    case
    when completed_at then "completed at #{completed_at.to_s(:short)} in #{runtime} sec"
    when run_at > Time.now then "to run at #{run_at.to_s(:short)}"
    when failed_at then "failed at #{failed_at.to_s(:short)} at #{progress}"
    when started_at then "started at #{started_at.to_s(:short)} (#{progress})"
    else "pending (scheduled at #{run_at.to_s(:short)})"
    end
  end
  
  def description
    super || handler.inspect
  end
  
  def self.scheduled?(tag)
    future(tag).limit(1).count > 0 
  end
  
  scope :future, lambda { |tag|
    where(:tag.eq => tag, :run_at.gt => Time.now)
  }
  
end