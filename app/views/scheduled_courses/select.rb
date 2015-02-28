class Views::ScheduledCourses::Select < Application::Widget

  needs :course
  def widget_content
    div :id => :selected_class, :class => 'rounded-corners-shadow' do
      teacher = course.teacher
      div :class => 'trainer' do
        img :src => teacher.photo.url, :alt => teacher.name,  :width => '155', :height => '155', :class => 'fltl-left-rounded-corners-shadow'
      end
      p do
        span :class => 'h1' do
          text course.course.course_group.name
        end
        text ' > '
        span :class => 'h2' do
          text course.name
        end
        text ' - '
        span :class => 'h1' do
          text money(course.price)
        end
      end
      h3 "trainer"
      p { link_to course.teacher.name, teacher_path(course.teacher)}
      h3 "schedule"
      p { text times(course) }
      h3 "availability"
      p { text "#{course.show_seats} available" }
    end
  end

end
