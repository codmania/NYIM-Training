class Views::Teachers::Show < Application::Widget
  def widget_content
    teacher = resource
    div :id => 'content_left' do

      heading ["Trainers", trainers_path], teacher.name
      
      widget Views::Teachers::IndexItem, :teacher => teacher, :name => false

      h2 'Upcoming Classes'
     
      button = teacher? || admin? ? :course_button_teacher : :course_button_student
      
      ul :class => 'col_button' do
        teacher.upcoming_classes.limit(5).each do |c|
          send button, c
        end
      end
      
        
      
      h2 'Testimonials'
      
      widget Views::Testimonials::Index, :collection => teacher.testimonials.testimonials, :pagination => false
    end
    div :id => 'content_right' do
      h2 'Bio'
      rawtext asset(resource.bio_asset_name)
    end
  end
  
  def course_button_teacher(course,options={})
    li({ :class => "course_button rounded-corners-shadow", :id => dom_id(course,:li) }.merge(options))  do
      link_to scheduled_course_path(course) do
        span do
          div :class => 'info' do
            text course.description
          end
        end
      end
    end
  end
  
  def course_button_student(course,options={})
    li({ :class => "course_button rounded-corners-shadow", :id => dom_id(course,:li) }.merge(options))  do
      link_to new_signup_path(:signup => { :scheduled_course_id => course.id, :course_id => course.course_id }) do
        span do
          div :class => 'info' do
            text course.description
          end
        end
      end
    end
  end
  
end
