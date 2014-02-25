module CoursesHelper

  include Application::Helpers::Dropdown

  def scheduled_courses_dropdown(course, options={ })
    classes = course ? course.scheduled_courses_available : []
    text    = course && classes.empty? ? 'No Class Scheduled' : 'Choose Date'
    options.reverse_merge! :name => :to_dropdown, :blank => text, :tag => true, :collection => classes
    to_dropdown(options)
  end

  def os_dropdown(course, options={ })
    os = course.nil? ? [] : (course.os ? [course.os] : [['Any', nil], *(site(:os))])
    options.reverse_merge! :tag => true
    options[:tag] ? options_for_select(os) : os
  end

  def course_group_form_content(form, w)
    form.semantic_errors
    form.inputs do
      form.input :name
      form.input :short_name
      form.input :pos
    end
    formtastic_button(form)
  end


  def course_form_content(form, w)
    form.semantic_errors
    form.inputs do
      form.input :course_group, :required => true
      form.input :name
      form.input :short_name
      form.input :pos
      form.input :price, :hint => 'USD', :input_html => { :value => form.object.read_attribute(:price).ifnil?('') { |p| p/100.0 } }
      form.input :hours
      form.input :os, :as => :select, :collection => site(:os), :include_blank => 'Any'
      form.input :promotional_price
      form.input :promotional_discount
      form.input :promotion_expires_at, :as => :string, :input_html => { 'data-datepicker' => true }

    end
    formtastic_button(form)
  end

  def course_price(resource)
    if resource.promotional?
      "#{money(resource.price)} (NOW #{money(resource.sale_price)})"
    else
      money(resource.price)
    end
  end

end