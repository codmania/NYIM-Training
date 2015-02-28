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
        div :class => 'rounded-corners-shadow checkout_text', :id=>'scroll' do
          text "You have added the \"#{resource.last.name}\" to your Cart. You may Checkout Now or "
          span 'add more classes below'
        end
      end
      widget Views::Payments::New, :record => payment
      div :class => :shopping_cart_table do 
        div :class => 'rounded-corners-shadow between_text', :id=>'scrollToSignup' do
          p "Add another class"
        end 
      end
      div :class => 'rounded-corners-shadow', :id=>'new_payment' do  
        widget Views::Signups::New, :record=>Signup.new(:created_by_id=>current_user.id)
      end

    end
  end

end