class NyimJobs::SendCertificates < NyimJobs::Base

  self.description =  "sending certificates"
  def perform
    transaction do
      if Site.site(:notify_when_certificate_available)
        in_batches Signup.confirmed.attendance.inthelasthour.reject(&:blank?) do |signup|

          Mailers::UserMailer.certificate({},{ :student => signup.student, :signup => signup })
          signup.update_attribute :certificate_mailed_on, Time.now

        end
      end
    end
  end
end