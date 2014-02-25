class Views::Signups::ShoppingCart < Application::Widgets::Index

  needs :payment => nil
  def widget_content
    if resource.empty? && Rails.env.production?
      p do
        text "Shopping cart empty"
      end
    else
      div :class => :shopping_cart_table do
        resource.each do |signup|
          div :id => dom_id(signup,:item), :class => css_class(signup) do
            p do
              text "#{signup.name}"
              text " (retake)" if signup.retake?
              text " (cancelation)" if signup.cancelation?
            end
            p :class => 'student' do text signup.student.full_name_with_email end unless signup.student == current_user
            p :class => 'discount' do text signup.discount_description end
            p :class => 'price' do text money(signup.price) end
          end
        end
        div :id => :shopping_cart_total, :class => 'rounded-corners-shadow total' do
          p "Total"
          p :class => 'price' do text money(payment.amount) end
        end
      end
      widget Views::Payments::New, :record => payment
    end
  end

end