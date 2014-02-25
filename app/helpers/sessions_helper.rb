module SessionsHelper
  
  class SessionFieldsTable < Application::Widgets::FormFieldsTable
    
    def content
      field :email, :text_field
      field :password, :password_field 
      button 'Log In'
      super
    end
  end
end
