DELAYED_JOB_PID_PATH = "#{Rails.root}/tmp/pids/delayed_job.pid"

def start_delayed_job
  Thread.new do
    'RAILS_ENV=production script/delayed_job run'
  end
end

def process_is_dead?
  begin
    pid = File.read(DELAYED_JOB_PID_PATH).strip
    Process.kill(0, pid.to_i)
    false
  rescue
    true
  end
end

if !File.exist?(DELAYED_JOB_PID_PATH) && process_is_dead?
  start_delayed_job unless Rails.env.development?
end