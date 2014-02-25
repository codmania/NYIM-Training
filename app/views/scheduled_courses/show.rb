class Views::ScheduledCourses::Show < Application::Widget
  def widget_content

    heading [resource.course_group.name, course_group_path(resource.course_group)], [resource.course.name, course_path(resource.course)], resource.starts_at

    admin_bar ['Edit', edit_scheduled_course_path(resource)],
              ['New Class', new_scheduled_course_path(:scheduled_course => { :course_id  => resource.course_id,
                                                                             :teacher_id => resource.teacher_id })]
    div :id => 'content_left' do
      h2 'Calendar view'
      widget FullCalendar::Widget, :options => { :event_class => :scheduled_session, :extra_params => { 'search[scheduled_course_id_equals]' => resource.id },
                                                 :year        => resource.starts_at.year, :month => resource.starts_at.month - 1 }
    end

    if admin? || teacher?
      div :id => 'content_right' do
        h2 'Students'
        #iframe :src => 'excel2007_outline.html', :frameborder => '0', :allowtransparency => 'true'
        widget Application::Widgets::Index, :collection => resource.attendances, :info => nil, :pagination => nil,
               :display_columns                         => [:student_name, :email, :phone, :retake]
      end
    end
  end

end