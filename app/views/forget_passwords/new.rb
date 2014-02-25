class Views::ForgetPasswords::New < Application::Widget
  def widget_content
    h2 'Forgot your password?'
    semantic_form_for(resource, :as => resource_name, :url => password_path(resource_name), :html => { :method => :post }) do |f|
      rawtext devise_error_messages!
      f.inputs do
        f.input :email
      end
      formtastic_button(f, "Send me reset password instructions")
    end
  end
end
