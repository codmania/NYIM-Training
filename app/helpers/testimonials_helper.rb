module TestimonialsHelper

  def testimonial_form_content(form, w)
    form.semantic_errors
    form.object.read = true
    form.object.name ||= form.object.student_info
    form.inputs do
      form.input :text, :input_html => {:size => '50x8'}
      form.input :display
      form.input :featured
      form.input :course, :hint => "#{form.object.class_info}"
      form.input :teacher
      form.input :name
      form.input :read
    end
    formtastic_button(form)
  end

end
