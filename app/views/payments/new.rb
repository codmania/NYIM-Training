class Views::Payments::New < Application::Widgets::New
  def widget_content
    self.record ||= controller.resource
    div :id => :new_payment, :class => 'rounded-corners-shadow' do
      semantic_form_for(record, :url => payments_path, :html => { :method => :post }) do |form|
        #text form.semantic_errors #(record)
        unless record.errors.empty?
          div :class => 'rounded-corners-shadow failed_payment' do
            p do
              errors(form.object)
              #text record.errors.inspect
            end
          end
          br
        end
        unless !admin? || record.payment_errors.empty?
          div :class => 'rounded-corners-shadow failed_payment' do
            record.payment_errors.each do |type, message|
              p do
                h3 type
                text message
              end
            end
          end
          br
        end
        hidden_field_tag :resource_param, record.class.name.underscore
        #text record.card.errors.inspect if record.card
        #text record.card.student.errors.inspect if record.card.student
        display_card_options = nil
        form.inputs do
          form.input :student_id, :as => :hidden
          form.input :order_id, :as => :hidden
          form.input :amount, :as => :hidden, :input_html => { :value => form.object.amount.cents/100.0 }
          form.input :custom_amount, :hint => 'Enter custom amount here for a package deal.' if admin?
          p do
            text 'You can read our terms and conditions '
            link_to display_asset_path('Policies'),
                    :remote  => false,
                    :onclick => "window.open(this.href,'Policies','');return false;" do
              b 'here'
            end
            text ' or any time by clicking Policies in the main menu.'
          end
          if admin?
            form.input :terms_and_conditions,
                       :as    => :boolean,
                       :input_html => { :checked => 'checked' },
                       :label => 'I have read and accept the terms and conditions'
          else
            form.input :terms_and_conditions,
                       :as    => :boolean,
                       :label => 'I have read and accept the terms and conditions'
          end
          record.type = 'CreditCardPayment' if record.type.blank? &&
            record.payment_options.include?('CreditCardPayment')
          display_card_options = record.type == 'CreditCardPayment'

          if record.payment_options.length > 1
            form.input :type,
                       :as            => :select,
                       :collection    => simple_dropdown(record.payment_options),
                       :include_blank => false,
                       :input_html    => { 'data-select-target' => 'CreditCardPayment',
                                           'data-select-show'   => "\#card_fields, \#card_input, \##{record.class.name.underscore}_card_input",
                                           'data-select-hide'   => "\##{record.class.name.underscore}_cvv_input",
                                           'data-select-write'  => "\##{record.class.name.underscore}_card_attributes_mandatory",
                                           'data-select-clear'  => "\##{record.class.name.underscore}_card_id"
                       }
          else
            form.input :type, :as => :hidden
          end
        end
        card_id = record.card_id
        div :id => 'card_input' do
          record.build_card(
            :mandatory  => display_card_options && card_id.blank? || nil,
            :address    => Address.new(:mandatory => true),
            :first_name => record.payer.first_name,
            :last_name  => record.payer.last_name
          ) unless record.card && record.card.new_record? || !record.can_have_card?

          form.inputs do
            display_card_fields = display_card_options && record.card.mandatory
            record.card_id      = card_id
            form.input :attempts, :as => :hidden
            form.input :card,
                       :collection    => record.credit_cards.collect { |p| [p.name, p.id] },
                       :include_blank => 'New Credit Card',
                       :wrapper_html  => { :style => ('display:none' unless display_card_options) },
                       :input_html    => { 'data-select-target' => '', 'data-select-show' => '#card_fields',
                                           'data-select-hide'   => "\##{record.class.name.underscore}_cvv_input",
                                           'data-select-write'  => "\##{record.class.name.underscore}_card_attributes_mandatory" } if record.can_have_card? && !record.credit_cards.empty?
            form.input :cvv,
                       :wrapper_html => { :style => ('display:none' if !display_card_options || display_card_fields) }
            form.input :test_response,
                       :as         => :select,
                       :collection => CreditCardPayment.test_responses unless CreditCardPayment.live? || !admin?
            if record.card
              form.semantic_fields_for :card do |card_form|
                #errors(record.card)
                card_form.inputs :id => 'card_fields', :style => ('display:none' unless display_card_fields) do
                  card_form.input :remember, :as => :boolean, :hint => 'Your credit card information is securely stored in a browser cookie. Untick if you do not wish a cookie to be set.'
                  card_form.input :card_type, :as => :select,
                                  :collection     => simple_dropdown(CreditCardPayment.supported_cardtypes),
                                  :include_blank  => 'Select card type'
                  card_form.input :mandatory, :as => :hidden
                  card_form.input :id, :as => :hidden, :input_html => { :value => '' }
                  card_form.input :first_name
                  card_form.input :last_name
                  card_form.input :number
                  card_form.input :cvv
                  card_form.input :month, :as => :select, :collection => (1..12).to_a
                  year = Date.today.year
                  card_form.input :year, :as => :select, :collection => (year..(year+10)).to_a
                  card_form.input :address,
                                  :collection    => record.credit_cards.map(&:address).uniq,
                                  :include_blank => 'New Address',
                                  :input_html    => { 'data-select-target' => '',
                                                      'data-select-show'   => '#address_fields',
                                                      'data-select-write'  => "\##{record.class.name.underscore}_card_attributes_address_attributes_mandatory" } unless record.credit_cards.empty?
                  card_form.object.address =
                    Address.new(:mandatory => !card_form.object.address_id || nil) unless card_form.object.address && card_form.object.address.new_record?
                  card_form.semantic_fields_for :address do |address_form|
                    #errors(address_form.object)

                    address_form.inputs :id    => 'address_fields',
                                        :style => ('display:none' unless address_form.object.mandatory) do
                      address_form.input :street_1, :label => "Street"
                      address_form.input :street_2, :label => "Street"
                      address_form.input :city
                      address_form.input :region_id,
                                         :label      => 'State',
                                         :as         => :select,
                                         :collection => UsRegion.dropdown
                      address_form.input :postal_code
                      address_form.input :mandatory, :as => :hidden
                    end

                  end
                end
              end
            end
          end
        end

        formtastic_button(form, 'Submit Payment')
      end

    end
  end

end
