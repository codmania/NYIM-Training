class StudentsController < UsersController

  resourceful_actions :defaults, :sidebar => :show, :list => :index

  before_filter :only => :sidebar do
    self.resource = current_user if request_options[:commit] != "Search"
  end

  member_scope :sidebar do
    Student.find_by_full_name_with_email(request_options[:student], current_user) || current_user
  end

  display_options :user_name, :created_at, :created_by, :company, :discount, :invoiceable, :edit,
                  :only => [:list, :create, :update]

  display_options :user_name, :created_at, :created_by, :company, :edit,
                  :only => :show

  action_component :sidebar do
    self.current_student = (resource if resource.is_a?(Student)) #assigns nil exlicitly otherwise
  end

  js :sidebar, :only => true do |page|
    if user = resource
      page.replace 'student_sidebar',
                   render_to_string(:widget => Views::Site::StudentSidebar.new(:user => user))
    end
  end

  # this needed if after login, reload?
  js :new do |page|
    page.hide 'loginbox'
    page.hide 'dimmer'
  end

end
