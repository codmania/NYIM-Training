class Views::Courses::Show < Application::Widget
  def widget_content

    heading [resource.course_group.name, course_group_path(resource.course_group)], resource.name, course_price(resource)

    admin_bar ['Edit', edit_course_path(resource)],
              ['New Course', new_course_path(:course => { :course_group_id => resource.course_group_id })],
              ['Schedule Class', new_scheduled_course_path(:scheduled_course => { :course_id => resource.id })],
              ['All Scheduled Classes', list_scheduled_courses_path(:search => { :course_id_equals => resource.id })],
              ['Upcoming Scheduled Classes', list_scheduled_courses_path(:search => { :course_id_equals => resource.id, :starts_at_gt => Time.now })]

    div :id => 'content_left' do
      upcoming_classes = ScheduledCourse.active.upcoming.where(:course_id.eq => resource.id).all(:limit => 5)

      ul :class => 'col_button' do
        upcoming_classes.each do |course|
          course_button(course)
        end
      end

      h2 'Calendar view'
      p {
        text 'hover over class to see info, click to go signup'
      }
      widget FullCalendar::Widget, :options => {
          :event_class  => :scheduled_course,
          :extra_params => { 'search[course_id_equals]' => resource.id },
          :year         => Time.now.year, :month => Time.now.month - 1
      }

      br :class => 'item_spacer'
      if upcoming_classes.empty?
        text 'No classes scheduled'
      else
        ul :class => 'col_button' do
          course_button(upcoming_classes.first, :id => :calendar_popup, :style => 'display:none;')
        end
      end

      h2 'Testimonials'

      widget Views::Testimonials::Index, :collection => resource.testimonials.testimonials, :pagination => false

    end

    div :id => 'content_right' do
      rawtext asset(resource.outline_asset_name)
    end

  end

  def course_button(course, options={ })
    li({ :class => "course_button rounded-corners-shadow", :id => dom_id(course, :li) }.merge(options)) do
      link_to new_signup_path(:signup => { :scheduled_course_id => course.id, :course_id => course.course_id }) do
        span do
          div :class => 'thumb' do
            img :src => course.teacher.photo.url(:small), :alt => course.teacher.name, :width => '30', :height => '30', :class => 'rounded-corners-shadow'
          end
          div :class => 'info' do
            text course.description
          end
        end
      end
    end
  end

end