class Views::Jobs::Launch < Application::Widget

  needs :result
  def widget_content

    h1 'Job > Launch '
    text result
    
  end

end
