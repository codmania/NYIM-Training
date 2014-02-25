class Application::Widgets::Index < Application::Widget

  needs :table_class => nil, :info => true,
  :pagination => [:top, :bottom], :collection => nil,  :display_columns => nil, :display_options => nil
  def default_table_class
    #self.display_options ||= controller.display_options
    columns_to_display = display_options ? display_options.options : display_columns || []
    table_class = Class.new(Application::Widgets::Table) do
      columns *columns_to_display
      row_classes :even, :odd
    end
  end

  def widget_content
    self.collection ||= controller.resource
    self.pagination = [] unless pagination.is_a?(Array)
    entry_name = controller.resource_name
    custom_table_class = "#{resource_class.to_s.pluralize}Helper::#{resource_class.to_s.pluralize}Table"
    self.table_class ||= (custom_table_class.constantize rescue default_table_class)
    div :class => 'index_table' do
      rawtext page_entries_info collection, :entry_name => entry_name if info
      rawtext will_paginate(collection, :remote => true) if pagination.include?(:top)
      widget table_class, :row_objects => collection
      rawtext will_paginate(collection, :remote => true) if pagination.include?(:bottom)
    end
  end

end