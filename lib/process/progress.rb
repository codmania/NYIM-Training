module Process::Progress
  
  # assume progress float column
  # assume completion_target integer completion_state
  def eta
    if progress && progress > 0 
      diff = (Time.now - run_at).abs.round
       (diff/progress).seconds.from_now
    end
  end
  
  def step_progress(step=1)
    return unless completion_target > 0
    self.completion_state += step
    self.progress = completion_state/completion_target
  end
  
  def step_progress!(step=1)
    step_progress(step) && save!
  end
  
  def set_progress(state,precision=2)
    if completion_target > 0 && (state - completion_state)/completion_target > 10^-precision
      self.completion_state = state
      self.progress = completion_state/completion_target
      true
    else
      false
    end
  end
  
  def set_progress!(state,precision=2)
    set_progress(state,precision) && save!
  end
  
  def percent_complete(precision=2)
    progress ? (progress * 100).round(precision) : 0
  end
  
end