ActionMailer::Base.default_url_options = {:host => "training-nyc.com"}

ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "gmail.com",
    :user_name => 'nyim.devel',
    :password => 'joetandle',
    :authentication => "plain",
    :enable_starttls_auto => true
}

ActionMailer::Base.sendmail_settings = {
    :location => "/usr/sbin/sendmail",
    #:arguments => "-F 'New York Interactive Media' -i -N 'never'"
    :arguments => "-i"
}

ActionMailer::Base.delivery_method = Rails.env.production? ? :sendmail : :smtp unless Rails.env.test?

#ActionMailer::Base.delivery_method = :smtp