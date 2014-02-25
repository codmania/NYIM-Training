class Application::Widgets::FormFieldsTable < FieldTable
  
  
  needs :form, :title => nil, :button => true
  
  def initialize(options = {}, &contents)
    @form = options[:form]
    @object = @form.object
    options[:title] ||= @form.object.class.to_s
    super(options, &contents)
  end
  
  def field(attribute, method = :text_field, note = nil, *args, &contents)
    options = args.extract_options!
    label = options.delete(:label) || attribute
    if contents then 
      super(label, note) { contents.call(@form) }
    else
      args = method, attribute, *args
      Rails.logger.warn args
      args << options unless options.empty?
      super label, note do 
        @form.send(*args)
      end
    end
  end
  
  def button(*args, &button_proc)
    if button_proc then 
      super
    else
      super() do 
        options = args.extract_options!
        options['data-button'] = true
        @form.submit(*(args << options))
      end
    end
  end
  
  
  
  
end
