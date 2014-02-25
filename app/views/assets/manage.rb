class Views::Assets::Manage < Application::Widgets::Index
  def widget_content
    #Mailers::UserMailer::PART_FORMATS
    
    name = params[:search][:name_equals]
    heading ['Manage Email Assets', manage_emails_sites_path], name
    
    link_to 'New', new_asset_path(:asset => { :name => name })
    super

  end
end