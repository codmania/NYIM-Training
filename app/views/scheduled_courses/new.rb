class Views::ScheduledCourses::New < Application::Widgets::New
  
  def widget_content
    h1 'Add New Class'
    #built = resource.scheduled_sessions && resource.scheduled_sessions.length || 0
    5.times { resource.scheduled_sessions.build }
    #semantic_form_for resource do |form|
    #  scheduled_courses_form(form)
    #end
    super
  end
  
end
