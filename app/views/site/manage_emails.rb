class Views::Site::ManageEmails < Application::Widget

  def widget_content
    heading 'Manage Email Assets'
    ul :class => :links do
      Mailers::UserMailer::MAILS.each do |mail|
        li :class => "rounded-corners-shadow" do
          link_to mail, manage_assets_path(:search => { :name_equals => mail })
        end
      end
    end
  end

end