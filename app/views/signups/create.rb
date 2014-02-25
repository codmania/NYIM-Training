class Views::Signups::Create < Views::Signups::New

  def widget_content
    unless resource.new_record?
      if resource.waiting?
        div :id => 'success', :class => 'box_striped' do
          text "You have been added to the waiting list for #{course} staring on #{date}. "
        end
      else
        rawtext asset 'signup'
      end
      self.record = Signup.new(:course => resource.course, :scheduled_course => resource.scheduled_course, :os => resource.os)

    else
      @submitted = true
      #  resource.errors.add(:student_email,resource.errors[:student])
    end

    super
  end

end
