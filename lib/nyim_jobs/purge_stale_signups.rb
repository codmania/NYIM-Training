class NyimJobs::PurgeStaleSignups < NyimJobs::Base

  self.description =  "purging stale signups"
  
  def perform
    Signup.transaction do
      in_batches Signup.past.pending, &:destroy
    end
  end

end


