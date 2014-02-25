class Testimonial < ActiveRecord::Base

  belongs_to :teacher
  belongs_to :course
  belongs_to :feedback

  default :read => false, :display => true

  # conditions:
  # * display TRUE   to select appropriate ones (this is default)
  # * read TRUE      to select ones that are read by at least one person
  scope :testimonials, lambda { |*a|
    where(:read.eq => true, :display.eq => true, :course_id.not_eq => nil, :teacher_id.not_eq => nil).
        order('featured DESC, updated_at DESC')
  }


end
