class Views::CourseGroups::Show < Application::Widget
  def widget_content

    h1 "#{resource.name} training in New York"
          admin_bar ['Edit', edit_course_group_path(resource)],
                    ['Add New Group', new_course_group_path],
                    ['Add New Course to Group', new_course_path(:course => { :course_group_id => resource.id })],
                    ['Courses in Group', list_courses_path(:search => { :course_group_id_equals => resource.id })]

    div :id => 'content_left' do

      h2 "Sign up for Group Classes"
      ul :class => 'col_button' do
        resource.courses.active.each do |course|
          li :class => "rounded-corners-shadow" do
            link_to course.name, course_path(course)
          end
        end
      end
      h3 "Customized Private & Corporate Training"

      #widget Views::CourseGroups::Corporate
      rawtext asset(resource.pricing_asset_name,'corporate_pricing')

      h2 'Testimonials'

      widget Views::Testimonials::Index, :collection => resource.testimonials.testimonials, :pagination => false

    end

    div :id => 'content_right' do
      rawtext asset(resource.outline_asset_name)
    end

  end

end
