class NyimJobs::Base #< Struct.new(*ATTRS)

  #class_inheritable_accessor :description
  class_attribute :description#, :instance_reader => false, :instance_writer => false

  ATTRS = [:options, :user, :tag, :job_class, :priority, :completion_target, :run_at, :interval]

  attr_accessor *ATTRS

  include Process::Hooks

  TASKS = [:purge_stale_signups, :send_course_reminders, :send_feedback_reminders, :delayed_user_mailer]
  TASKS_CLASSES = {}
  TASKS.each { |task| TASKS_CLASSES[task] = "NyimJobs::#{task.to_s.camelize}" }

  def self.launch(task,force,options={})
    klass = TASKS_CLASSES[task.to_sym]
    if klass
      text = if Job.scheduled?(klass)
        "found scheduled"
      else
        force = true
        "not found"
      end
      Rails.logger.info "[JOBS] #{klass} #{text}"
      if force
        Rails.logger.info "[JOBS] #{klass} launched"
      klass.constantize.new(options).launch if force
      end
    true
    else
    false
    end
  end

  self.register = [:description, :user, :tag, :priority, :completion_target, :run_at]
  self.fatal_exceptions = []

  #self.description = ""

  def in_batches(scope,size=1000,&block)
    steps = scope.count/size
    (0..steps).each do |step|
      scope.limit(size).offset(step * size).all.each(&block)
    end
  end

  def initialize(init={},&block)
    ATTRS.each { |a| send("#{a}=",init.delete(a)) }
    self.options = init.reverse_merge(options || {})
    self.tag ||= self.class.name.underscore.split('/')[1].humanize
    self.job_class ||= 'Job'
  #self.description = "hi"#self.class.description
  #self.interval ||= 60
  end

  def launch(time = nil)
    job_class.constantize.enqueue(self, :run_at => time || run_at)
  end

  def error(job,exc)
    Airbrake.notify(exc)
    super(job,exc)
  end

# this hook implements a cron-like function
#def success
# super
#  launch(:run_at => interval.minutes.since(run_at || Time.now) if interval
#end

end