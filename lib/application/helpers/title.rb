class Application::Helpers::Title < Application::Widget
  
  needs :headings
  
  def widget_content
    p do
      headings.each_with_index do |h,i|
        span :class => 'h1' do
          h.is_a?(Array) ? link_to(*h) : text(h) 
        end
        text ' > ' unless i == headings.length - 1
      end
    end
  end
  
end
    
