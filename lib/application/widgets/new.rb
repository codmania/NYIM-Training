class Application::Widgets::New < Application::Widget
  
  needs :form_fields => nil, :form_options => { }, :block_only => nil, :button => true, :record => nil, 
  :custom_form_method => nil, :content_method => nil
  
  def default_form_content(form,*args)
    errors(record)
    form.inputs 
    formtastic_button(form)
  end
  
  def widget_content(&block)
    self.record ||= controller.resource
    #logger.warn [record, record.class].inspect
    resource_name = record.class.name.underscore
    self.custom_form_method ||= "#{resource_name}_form"
    if respond_to?(custom_form_method) 
      parent.send(custom_form_method,resource, form_options,&block)
    elsif respond_to?(:semantic_form_for)
      # formtastic
      method = record.new_record? ? :post : :put
      form_options[:method] = method
      form_options[:html] ||= {}
      form_options[:html].merge!( :method => record.new_record? ? :post : :put )
      semantic_form_for(record, form_options) do |form|
        self.content_method ||= ("#{resource_name}_form_content" if respond_to?(:"#{resource_name}_form_content"))
        self.content_method ||= :default_form_content 
        send(content_method,form,self)
        call_form_block(block,form)
      end
    else
      form(&block)
    end 
  end 
  
  def errors(record)
    if record.errors.any?
        ul do 
          record.errors.full_messages.each do |msg|
            li do 
              text msg 
            end
          end
        end
      end
  end
  
  def form(&block) 
    
    form_for record, form_options do |form|
      errors(record)
      form_fields_class = "#{record.class.to_s.pluralize}Helper::#{record.class.to_s.pluralize}FormFieldsTable"
      form_fields_class = form_fields_class.constantize rescue nil
      form_fields ||= form_fields_class || Application::Widgets::DefaultFormFieldsTable 
      options = { :button => button, :form => form }
      
      call_form_block(block,form)
      
      widget(form_fields, options) unless block_only
      
    end
  end
  
  def call_form_block(block,form)
    if block 
      if block.arity == 0 
        super(&block)
      else
        super { block.call(form) }
      end
    end
  end
  
end
