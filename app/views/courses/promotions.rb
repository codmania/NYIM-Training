class Views::Courses::Promotions < Application::Widgets::List

  def widget_content
    h1 'Promotions'
    h2 'Special Sales Packages'
    rawtext asset('packages')
    unless resource.empty?
      h2 'Discounts'
      self.info = false
      super
    end

  end

  def item(c)
    widget ::Views::Courses::Promotion, :resource => c
  end
end
