class Application::Widgets::DefaultFormFieldsTable < Application::Widgets::FormFieldsTable
  
  needs :button
  
  def content
    @object.attributes.each do |a|
      field a.first, :text_field, 'TEST'
    end
    button if @button
    super
  end
  
  
end
