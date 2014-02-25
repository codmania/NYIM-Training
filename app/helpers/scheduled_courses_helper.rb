module ScheduledCoursesHelper

  def dropdown(klass,options = {})
    id_f = options[:id] || :id
    name_f = options[:name] || :name
    list = options[:search] ? klass.search(options[:search]) : klass.all 
    dropdown = list.map do |element|
      [element.send(name_f), element.send(id_f)]
    end
    niltext = options[:nil] || options[:add_to_top]
    dropdown.unshift([niltext,nil]) if niltext
    niltext = options[:add_to_bottom]
    dropdown.push([niltext,nil]) if niltext
    dropdown
  end
  
  def scheduled_course_form_content(form,w)
    
    form.semantic_errors
    form.inputs do
      form.input :course
      form.input :teacher, :collection => Teacher.active
      form.input :location
      form.input :seats, :input_html => { :readonly => form.object.new_record? }, :hint => 'use manage seats in class listing to add/remove seats or to close signups'
      form.input :price, :hint => 'leave blank for default price', :input_html => { :value => form.object.read_attribute(:price).ifnil?('') { |p| p/100.0} }
    end
    formtastic_button(form)
    w.h2 'Schedule'
    form.semantic_fields_for :scheduled_sessions do |session_form|
      scheduled_session_form_content(session_form,w)
    end
    formtastic_button(form)
  end
  
  def scheduled_session_form_content(form,w)
    
    form.inputs do 
      unless form.object.new_record?
        form.input :_destroy, :as => :boolean, :label => 'delete'
      end
      form.input :starts_at, :as => :string, :input_html => { 'data-datepicker' => datepicker(form.object.starts_at) }
      form.input :duration, :hint => "minutes"      
    end
    
  end

  def datepicker(dt)
    dt ? dt.to_s(:js) : ''
  end

  def times(course)
    course.scheduled_sessions.map(&:to_s).join(', ')
  end
  
  
  
end