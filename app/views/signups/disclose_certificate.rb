class Views::Signups::DiscloseCertificate < Application::Widget
  
  needs :pdf => nil
  
  def widget_content
    course = resource
    # for pdf, image should specify full local path
    background_img = pdf ? [Rails.root,'public'] : []
    background_img << '/images/certificate.jpg'
    img :src => File.join(*background_img), :style => 'z-index:-1;'  
    div :class=>'display_certificate' do
      div :class=>'display_certificate_student' do
        text course.student.full_name.titlecase
        rawtext '&nbsp;'
      end
      div :class=>'display_certificate_course' do
        text course.course.name
      end
      div :class=>'display_certificate_date' do
        text course.ends_at.strftime("%B %Y")
      end
    end
  end
end
