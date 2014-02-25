class Teacher < User

  # probably bug in 3.1.3 uncomment if works :FIXME:
  belongs_to :created_by, :class_name => 'User'
  belongs_to :parent, :class_name => 'User'

  has_many :scheduled_courses
  has_many :signups, :through => :scheduled_courses
  has_many :feedbacks, :through => :scheduled_courses

  has_many :comments, :foreign_key => :user_id
  has_many :scheduled_sessions, :through => :scheduled_courses
  has_many :courses, :through => :scheduled_courses
  has_many :testimonials

  delegate :bio, :extra_subjects, :to => :profile

  has_one :profile
  accepts_nested_attributes_for :profile

  def self.default_photo_path(name,full=true)
    path = full ? [Rails.root,"public"] : []
    File.join(*(path << "/design/default_assets/trainers/#{name}.jpg"))
  end

  has_attached_file :photo, :path => ":rails_root/public/system/#{Rails.env}/:attachment/:id/:style/:filename",
    :url => "/system/#{Rails.env}/:attachment/:id/:style/:filename",
    :styles => { :small => "155x155" },
    :default_url => default_photo_path('Joe',false)

  attr_accessible :photo, :profile_attributes

  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => ["image/jpeg", "image/JPEG", "image/jpg"]
  validates_attachment_size :photo, :in => 0..5.megabyte

  before_validation :set_photo

  def set_photo
    self.photo = first_existing(name_camel,first_name.titlecase) unless photo?
  end

  def first_existing(file, *args)
    File.new(self.class.default_photo_path(file)) if file
  rescue Errno::ENOENT
    first_existing(*args) unless args.empty?
  end

  def upcoming_classes
    scheduled_courses.active.upcoming
  end

  def profile_with_default
    profile_without_default || Profile.new
  end

  has_asset :bio

  alias_method_chain :profile, :default

end
