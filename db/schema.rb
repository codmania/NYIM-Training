# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140405143431) do

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id",   :null => false
    t.string   "addressable_type", :null => false
    t.string   "street_1",         :null => false
    t.string   "street_2"
    t.string   "city",             :null => false
    t.integer  "region_id"
    t.string   "custom_region"
    t.string   "postal_code",      :null => false
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.string   "format"
    t.integer  "index"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", :force => true do |t|
    t.string   "first_name", :limit => 40
    t.string   "last_name",  :limit => 40
    t.string   "number",     :limit => 16
    t.integer  "month"
    t.integer  "year"
    t.string   "card_type",  :limit => 20
    t.integer  "student_id"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["student_id"], :name => "index_cards_on_student_id"

  create_table "comments", :force => true do |t|
    t.integer  "feedback_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["feedback_id"], :name => "index_comments_on_feedback_id"

  create_table "companies", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "url",               :limit => 100
    t.boolean  "display_with_url"
    t.boolean  "display_as_client"
    t.boolean  "featured"
    t.integer  "pos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["featured", "name"], :name => "index_companies_on_featured_and_name"
  add_index "companies", ["name"], :name => "index_companies_on_name"

  create_table "countries", :force => true do |t|
    t.string "name",                       :null => false
    t.string "official_name",              :null => false
    t.string "alpha_2_code",  :limit => 2, :null => false
    t.string "alpha_3_code",  :limit => 3, :null => false
  end

  add_index "countries", ["alpha_2_code"], :name => "index_countries_on_alpha_2_code"

  create_table "course_groups", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "pos"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "course_groups", ["pos"], :name => "index_course_groups_on_pos"
  add_index "course_groups", ["slug"], :name => "index_course_groups_on_slug", :unique => true

  create_table "courses", :force => true do |t|
    t.integer  "course_group_id"
    t.string   "name"
    t.string   "short_name"
    t.integer  "pos"
    t.integer  "price"
    t.boolean  "active"
    t.string   "os"
    t.integer  "hours"
    t.integer  "promotional_discount"
    t.integer  "promotional_price"
    t.datetime "promotion_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "courses", ["course_group_id"], :name => "index_courses_on_course_group_id"
  add_index "courses", ["name"], :name => "index_courses_on_name"
  add_index "courses", ["slug"], :name => "index_courses_on_slug", :unique => true

  create_table "credit_cards", :force => true do |t|
    t.string   "store_key",  :limit => 40
    t.string   "name",       :limit => 40
    t.integer  "student_id"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_cards", ["student_id"], :name => "index_credit_cards_on_student_id"

  create_table "delayed_jobs", :force => true do |t|
    t.float    "progress",          :default => 0.0
    t.integer  "completion_target", :default => 0
    t.integer  "completion_state",  :default => 0
    t.integer  "user_id"
    t.string   "tag"
    t.integer  "job_id"
    t.string   "job_type"
    t.string   "description"
    t.string   "failed_with"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "last_error_at"
    t.integer  "runtime"
    t.boolean  "fatal"
    t.integer  "priority",          :default => 0
    t.integer  "attempts",          :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "failed_payments_purchases", :id => false, :force => true do |t|
    t.integer "signup_id"
    t.integer "payment_id"
  end

  add_index "failed_payments_purchases", ["payment_id"], :name => "index_failed_payments_purchases_on_payment_id"

  create_table "feedbacks", :force => true do |t|
    t.integer  "scheduled_course_id"
    t.text     "text"
    t.boolean  "display"
    t.boolean  "read"
    t.text     "general"
    t.text     "most_useful"
    t.text     "least_useful"
    t.integer  "knowledge"
    t.integer  "patience"
    t.integer  "location"
    t.integer  "cleanliness"
    t.integer  "materials"
    t.text     "how_to_improve"
    t.text     "why_nyim"
    t.boolean  "recommend"
    t.boolean  "reference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["display"], :name => "index_feedbacks_on_display"
  add_index "feedbacks", ["read"], :name => "index_feedbacks_on_read"
  add_index "feedbacks", ["scheduled_course_id"], :name => "index_feedbacks_on_scheduled_course_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "venue_link"
    t.string   "map_info"
    t.text     "directions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true
  end

  create_table "payments", :force => true do |t|
    t.string   "type"
    t.integer  "amount"
    t.integer  "submitter_id"
    t.integer  "student_id"
    t.integer  "card_id"
    t.datetime "completed_at"
    t.boolean  "success"
    t.boolean  "refund"
    t.integer  "ip"
    t.string   "order_id",     :limit => 32
    t.string   "failed_with"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "invoice_sent"
  end

  add_index "payments", ["completed_at"], :name => "index_payments_on_completed_at"
  add_index "payments", ["student_id"], :name => "index_payments_on_student_id"
  add_index "payments", ["submitter_id"], :name => "index_payments_on_submitter_id"
  add_index "payments", ["type"], :name => "index_payments_on_type"

  create_table "phone_numbers", :force => true do |t|
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.string   "country_code",   :limit => 3
    t.string   "number",         :limit => 12
    t.string   "extension",      :limit => 10
    t.string   "type",           :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_numbers", ["phoneable_id", "phoneable_type"], :name => "index_phone_numbers_on_phoneable_id_and_phoneable_type"

  create_table "profiles", :force => true do |t|
    t.integer  "teacher_id"
    t.string   "extra_subjects", :limit => 200
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["teacher_id"], :name => "index_profiles_on_teacher_id"

  create_table "regions", :force => true do |t|
    t.integer "country_id",   :null => false
    t.string  "code",         :null => false
    t.string  "name",         :null => false
    t.string  "abbreviation", :null => false
    t.string  "group"
  end

  add_index "regions", ["code"], :name => "index_regions_on_code"

  create_table "scheduled_courses", :force => true do |t|
    t.integer  "course_id"
    t.integer  "teacher_id"
    t.integer  "location_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "seats"
    t.integer  "seats_available"
    t.integer  "price"
    t.integer  "promotional_discount"
    t.integer  "promotional_price"
    t.datetime "promotion_expires_at"
    t.integer  "hours"
    t.string   "os"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "scheduled_courses", ["active"], :name => "index_scheduled_courses_on_active"
  add_index "scheduled_courses", ["course_id"], :name => "index_scheduled_courses_on_course_id"
  add_index "scheduled_courses", ["promotion_expires_at", "promotional_discount"], :name => "index_scheduled_courses_on_promotion"
  add_index "scheduled_courses", ["slug"], :name => "index_scheduled_courses_on_slug", :unique => true
  add_index "scheduled_courses", ["starts_at", "ends_at"], :name => "index_scheduled_courses_on_starts_at_and_ends_at"
  add_index "scheduled_courses", ["teacher_id"], :name => "index_scheduled_courses_on_teacher_id"

  create_table "scheduled_sessions", :force => true do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "scheduled_course_id"
    t.boolean  "active"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scheduled_sessions", ["scheduled_course_id"], :name => "index_scheduled_sessions_on_scheduled_course_id"
  add_index "scheduled_sessions", ["starts_at"], :name => "index_scheduled_sessions_on_starts_at"

  create_table "signups", :force => true do |t|
    t.integer  "course_id"
    t.integer  "scheduled_course_id"
    t.integer  "student_id"
    t.integer  "submitter_id"
    t.integer  "created_by_id"
    t.integer  "feedback_id"
    t.integer  "payment_id"
    t.integer  "price"
    t.string   "transaction_code"
    t.text     "discount_description"
    t.datetime "confirmed_at"
    t.string   "status"
    t.string   "os"
    t.boolean  "certificate_to_be_mailed"
    t.boolean  "purchase_type"
    t.datetime "certificate_mailed_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signups", ["created_by_id"], :name => "index_signups_on_created_by_id"
  add_index "signups", ["scheduled_course_id"], :name => "index_signups_on_scheduled_course_id"
  add_index "signups", ["status", "purchase_type"], :name => "index_signups_on_status_and_purchase_type"
  add_index "signups", ["student_id"], :name => "index_signups_on_student_id"
  add_index "signups", ["submitter_id"], :name => "index_signups_on_submitter_id"

  create_table "sites", :force => true do |t|
    t.string   "linkpoint_store_number"
    t.string   "linkpoint_certificate"
    t.string   "linkpoint_test_store_number"
    t.string   "linkpoint_test_certificate"
    t.string   "email"
    t.string   "admin_email"
    t.string   "phone"
    t.string   "fax"
    t.string   "forum_link"
    t.string   "upload_dir"
    t.string   "site_name"
    t.string   "stylesheet"
    t.boolean  "linkpoint_live_mode"
    t.boolean  "account_activation_required"
    t.boolean  "notify_when_course_confirmed"
    t.boolean  "notify_when_seat_available"
    t.boolean  "notify_when_account_created"
    t.boolean  "notify_before_course_starts"
    t.boolean  "notify_when_course_ends"
    t.boolean  "notify_when_certificate_available"
    t.boolean  "notify_invoice"
    t.boolean  "notify_submitter_when_student_course_confirmed"
    t.boolean  "notify_when_certificates_are_to_be_mailed"
    t.integer  "payment_timeout_interval"
    t.integer  "returning_customer_discount"
    t.integer  "retake_fee"
    t.integer  "refund_fee"
    t.integer  "max_payment"
    t.integer  "default_course_hours"
    t.integer  "default_course_seats"
    t.integer  "default_session_duration"
    t.integer  "default_promotion_duration"
    t.integer  "course_check_interval"
    t.string   "os"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seo_tag"
  end

  create_table "testimonials", :force => true do |t|
    t.integer  "teacher_id"
    t.integer  "course_id"
    t.integer  "feedback_id"
    t.text     "text"
    t.string   "name"
    t.string   "student_info"
    t.string   "class_info"
    t.boolean  "display"
    t.boolean  "read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",     :default => false
  end

  add_index "testimonials", ["course_id", "display", "read"], :name => "index_testimonials_on_course_id_and_display_and_read"
  add_index "testimonials", ["featured", "read", "display"], :name => "index_testimonials_on_featured_and_read_and_display"
  add_index "testimonials", ["feedback_id"], :name => "index_testimonials_on_feedback_id"
  add_index "testimonials", ["teacher_id", "display", "read"], :name => "index_testimonials_on_teacher_id_and_display_and_read"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",   :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "parent_id"
    t.integer  "created_by_id"
    t.integer  "company_id"
    t.string   "role"
    t.integer  "discount"
    t.boolean  "invoiceable"
    t.string   "encrypted_password",     :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "active",                                :default => true
    t.string   "slug"
    t.datetime "reset_password_sent_at"
    t.integer  "position"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role", "created_by_id"], :name => "index_users_on_role_and_created_by_id"
  add_index "users", ["role", "email", "first_name", "last_name"], :name => "index_users_on_role_and_email_and_first_name_and_last_name"
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

end
