class Views::Site::Promotions < Application::Widget

  needs :promotions => nil

  def widget_content
    self.promotions ||= Course.promotions.active
    promotions.each do |promotion|
      widget ::Views::Courses::Promotion, :resource => promotion
    end
  end
end
