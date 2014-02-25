class Views::Testimonials::List < Application::Widgets::Index
  #needs :display_options => nil, :search_options => Signup.search
  def widget_content
    h1 'Testimonials'
    p do
      link_to "Add New Testimonial", new_testimonial_path
    end
    p do
      link_to "Manage Testimonials", manage_testimonials_path
    end
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm do |f|
      f.inputs :class => 'multi-column-list' do
        courses = Course.all
        f.input :feedback_id_is_null, :as => :boolean, :label => 'Only legacy', :required => false
        f.input :feedback_id_is_not_null, :as => :boolean, :label => 'Only non-legacy', :required => false

        f.object.course_id_in ||= courses.map(&:id)
        f.input :course_id_in, :as => :check_boxes, :required => false, :label => 'Course', :collection => to_dropdown(:collection => courses)
      end
      f.inputs :class => 'multi-column-list' do
        teachers               = Teacher.all
        f.object.teacher_id_in ||= teachers.map(&:id)
        f.input :teacher_id_in, :as => :check_boxes, :required => false, :label => 'Trainer', :collection => to_dropdown(:collection => teachers)
      end
      f.inputs do
        f.object.read_in ||= [true, false]
        f.input :read_in, :label => 'Read', :as => :check_boxes, :collection => boolean_collection,
                :member_label    => proc { |x| yesno(x) }, :required => false
        f.object.display_in ||= [true, false]
        f.input :display_in, :label => 'To display', :as => :check_boxes, :collection => boolean_collection,
                :member_label       => proc { |x| yesno(x) }, :required => false
      end
    end
  end

end