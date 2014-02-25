module Application::Helpers::AjaxLinks

  def link_to(*args)
    options = args.extract_options!
    super(*(args << options.reverse_merge(:remote => true)))
  end

  def button_to(*args)
    options = args.extract_options!
    options[:class] = "link #{options[:class]}"
    super(*(args << options.reverse_merge(:remote => true)))
  end

  def form_for(*args)
    options = args.extract_options!
    super(*(args << options.reverse_merge(:remote => true)))
  end

  #def form_tag(*args)
  #  options = args.extract_options!
  #  super(*(args << options.reverse_merge(:remote => true)))
  #end

end