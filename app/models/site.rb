class Site < ActiveRecord::Base

  after_save :clear
  after_destroy :clear

  class_attribute :_site, :instance_reader => false, :instance_writer => false

  # new class method for creating a default site frontend 
  default :linkpoint_store_number                         => "854690",
          :linkpoint_certificate                          => "./config/linkpoint_certificate.pem",
          :linkpoint_test_store_number                    => "1909647726",
          :linkpoint_test_certificate                     => './config/linkpoint_test_certificate.pem',
          :linkpoint_live_mode                            => false,
          :payment_timeout_interval                       => 300,
          :returning_customer_discount                    => 10,
          :retake_fee                                     => 25,
          :refund_fee                                     => 25,
          :max_payment                                    => 10000000,
          :os                                             => 'mac pc',
          :email                                          => 'info@nyim.com',
          :admin_email                                    => 'admin@nyim.com',
          :phone                                          => '646 209 2333',
          :fax                                            => '718 770 7696',
          :forum_link                                     => 'newyorkinteractivemedia.com/phpBB2',
          :default_course_hours                           => 1,
          :default_course_seats                           => 10,
          :default_session_duration                       => 60,
          :default_promotion_duration                     => 1,
          :course_check_interval                          => 24,
          :account_activation_required                    => false,
          :notify_when_course_confirmed                   => true,
          :notify_when_seat_available                     => true,
          :notify_when_account_created                    => true,
          :notify_before_course_starts                    => true,
          :notify_when_course_ends                        => true,
          :notify_when_certificate_available              => true,
          :notify_invoice                                 => true,
          :notify_submitter_when_student_course_confirmed => true,
          :notify_when_certificates_are_to_be_mailed      => true,
          :site_name                                      => "New York Interactive Media",
          :seo_tag                                        => "Training Course Classes in NYC New York City Connecticut and New-Jersey"

  validates_format_of :linkpoint_store_number, :linkpoint_test_store_number, :with => /[0-9]+/
  validates_format_of :linkpoint_certificate, :linkpoint_test_certificate, :with => /.*\.pem/

  validates_numericality_of :default_course_hours, :integer_only => true
  validates_numericality_of :default_session_duration, :integer_only => true
  validates_numericality_of :default_promotion_duration, :integer_only => true
  validates_numericality_of :default_course_seats, :integer_only => true
  validates_numericality_of :retake_fee
  validates_numericality_of :refund_fee
  validates_numericality_of :max_payment, :integer_only => true
  validates_numericality_of :returning_customer_discount, :in => 0..100, :integer_only => true

  validates :email, :admin_email, :email => true

  validates_format_of :phone, :fax, :with => /[0-9\ \-\+\.]+/


  module ClassMethods
    def clear
      self._site = nil
      CreditCardPayment.clear
    end

    def get_site
      self._site ||= clear
    end

    def get_or_set
      self._site ||= first || create!
    end

    def get_option(a)
      get_or_set.send(a)
    end

  end

  extend ClassMethods

  def clear
    self.class.clear
  end

  def os
    read_attribute(:os).ifnil? { |x| x.split(/\s+/) }
  end

  def slug
    seo_tag ? seo_tag.parameterize : ''
  end

  # this is the only entrypoint for cron
  def self.launch_jobs
    ["PurgeStaleSignup", "SeatAvailable", "SendCertificate", "SendCourseReminder", "SendFeedbackReminder"].each &:launch
  end

end
