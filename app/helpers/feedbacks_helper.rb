module FeedbacksHelper
  def feedback_form_content(form, w)
    form.semantic_errors
    form.inputs do
      form.input :text, :label => 'Public review of your experience',
                 :hint         => 'this may appear as a testimonial on our site',
                 :input_html   => { :size => '50x5' }

      form.input :how_to_improve, :label => 'Private feedback',
                       :hint         => 'this will never appear on our site',
                       :input_html   => { :size => '50x5' }

    end
    #formtastic_button(form) unless w.resource.is_a?(Signup)
  end

end