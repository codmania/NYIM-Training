class Application::Widgets::List < Application::Widget

  needs :pagination => true, :info => true, :pagination_top => true, :pagination_bottom => true, :collection => nil, :item_method => :item, :item_class => nil
  def default_table_class(resource_class)
    Class.new(Application::Widgets::Table) { default_columns(resource_class) }
  end

  def widget_content
    self.collection ||= controller.resource
    rawtext page_entries_info collection if pagination && info
    rawtext will_paginate(collection, :remote => true) if pagination && pagination_top
    if item_class.is_a? Class
      collection.each { |record| widget item_class, :item => record }
    else
      collection.each { |record| send item_method, record }
    end
    rawtext will_paginate(collection, :remote => true) if pagination && pagination_bottom
  end

end