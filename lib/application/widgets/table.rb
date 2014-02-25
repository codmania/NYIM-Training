class Application::Widgets::Table < Erector::Widgets::Table

  def self.default_columns(resource_class)
    @resource_class ||= resource_class
    columns(*@resource_class.column_names) if @resource_class
  end

  def self.columns(*names)
    names.each do |c|
      column(c) do |r|
        column_helper = :"#{c}_column"
        if respond_to? column_helper
          send(column_helper, r, self)
        else
          text r.send c
        end
      end
    end
  end


  def row(object, index) #:nodoc:
    tr(:id => helpers.dom_id(object), :class => row_css_class(object, index)) do
      column_definitions.each do |column_def|
        td do
          self.instance_exec(object, &column_def.cell_proc)
        end
      end
    end
  end

end
