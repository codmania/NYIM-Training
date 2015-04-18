class NyimJobs::SendCertificates < NyimJobs::Base
  self.description =  "sending certificates"
  def perform
    if Site.site(:notify_when_certificate_available)
      Signup.confirmed.attendance.inthelasthour.certificates_to_be_mailed.reject(&:blank?).each do |signup|

        Mailers::UserMailer.certificate({},{ :student => signup.student, :signup => signup })
        signup.update_attribute :certificate_mailed_on, Time.now

      end
    end
  end
end