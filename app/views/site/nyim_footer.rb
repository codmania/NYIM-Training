# coding: utf-8
class Views::Site::NyimFooter < Erector::Widget
  def content
    div :class => 'footer' do
      div :id => 'footer_left' do
        h3 do
          text 'CLIENT TESTIMONIALS '
          link_to 'MORE »', testimonials_path
        end
        testimonial = Testimonial.testimonials.limit(1).first
        if testimonial
        p do
          text testimonial.text.truncate(352, :omission => ' ...', :separator => ' ')
        end
        p do
          text " - #{testimonial.name} attended #{testimonial.course.name}"
        end
        else
          text 'No testimonials'
        end
      end
      div :id => 'footer_right' do
        rawtext asset('footer right')
      end
      div :id => 'footer_center' do
        h3 do
          text 'PARTIAL CLIENT LIST '
          link_to 'MORE »', companies_path
        end
        p do
          text Company.clients.limit(25).map(&:name).join(' • ')
        end
      end
    end
  end
end
