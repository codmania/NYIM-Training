class Views::Courses::Promotion < Application::Widget
  def widget_content
    div :id => dom_id(resource, :promotion), :class => 'rounded-corners-shadow promotion' do
      p do
        text resource.name
        text ' '
        text course_price(resource)
        text ' - '
        if resource.promotional_discount && resource.promotional_discount > 0
          text resource.promotional_discount
          text '% off'
        end
      end
    end
  end

end