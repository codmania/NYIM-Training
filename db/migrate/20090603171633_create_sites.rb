class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites  , :force => true do |t|
      # stylesheet to use for the site
      #t.string :content_type
      #t.string :filename
      #t.integer :size
      
      # various further preferences
      t.string :linkpoint_store_number, 
      :linkpoint_certificate, 
      :linkpoint_test_store_number, 
      :linkpoint_test_certificate,
      :email,
      :admin_email,
      :phone,
      :fax,
      :forum_link,
      :terms_and_conditions,
      :asset_root_dir,
      :upload_dir,
      :site_name,
      :stylesheet
      
      t.boolean :linkpoint_live_mode,
      :account_activation_required,
      :notify_when_course_confirmed,
      :notify_when_seat_available,      
      :notify_when_account_created,
      :notify_before_course_starts,
      :notify_when_course_ends,
      :notify_when_certificate_available, 
      :notify_invoice,
      :notify_submitter_when_student_course_confirmed,
      :notify_when_certificates_are_to_be_mailed
      
      t.integer :payment_timeout_interval,
      :returning_customer_discount,
      :retake_fee,
      :refund_fee,
      :max_payment,
      :default_course_hours,
      :default_course_seats,
      :default_session_duration,
      :default_promotion_duration,
      :course_check_interval
      
      t.string :os
      t.timestamps
    end
  end
  
  def self.down
    drop_table :sites
  end
end
