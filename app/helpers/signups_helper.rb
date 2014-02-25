module SignupsHelper
  # :TODO
  def css_class(signup)
    'rounded-corners-shadow'
  end

  def update_sidebar(page)
    page.replace 'sidebar', render_to_string(:widget => Views::Site::UserPanel, :user => current_user) if success
  end

  def signup_scheduled_courses_dropdown(signup, options={ })
    course = signup.course
    classes = course ? course.scheduled_courses_available.where(:id.not_eq => signup.scheduled_course_id) : []
    text    = 'Cancel'
    options.reverse_merge! :name => :to_dropdown, :blank => text, :tag => true, :collection => classes
    to_dropdown(options)
  end

end
