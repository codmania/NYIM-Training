module UsersHelper
  def account_fields(form, w)
    form.input :mandatory, :as => :hidden if form.object.is_a?(Student)
    form.input :first_name
    form.input :last_name
    form.input :email
    new_record = form.object.new_record?
    hint       = new_record ? 'Automatically generated if left blank' : 'Unchanged if left blank'
    form.input :password, :hint => hint, :required => false
    form.input :password_confirmation, :required => false
  end

  def user_form_content(form, w)
    form.inputs do
      account_fields(form, w)
    end
    formtastic_button(form)
  end

  def student_form_content(form, w)
    student_fields(form, w)
    formtastic_button(form)
  end

  def student_fields(form, w, title=nil, form_id='student')
    w.errors(form.object)
    form.inputs title do
      account_fields(form, w)
      if admin?
        form.input :discount
        form.input :invoiceable
      end
      form.semantic_fields_for :phone_numbers do |phone_number_form|
        phone_number_form.inputs do
          phone_number_form.input :number, :label => 'Phone number'
        end
      end
      new_company_selected = !params[:company].blank?
      if admin?
        w.li do
          w.label 'Company'
          w.select_tag 'company',
            options_for_select([['Existing Company', ''],
                                ['New Company', 'true']],
                               new_company_selected||''),
            'data-select-target' => 'true',
            'data-select-show'   => '#new_form',
            'data-select-clear'  => "##{form_id}_company_name",
            'data-select-hide'   => "##{form_id}_company_name_input",
            'data-select-write'  => "##{form_id}_company_attributes_mandatory"
          w.text ' '
          w.link_to "Edit #{form.object.company.name}", edit_company_path(form.object.company_id) if form.object.company_id && form.object.company
        end
        unless form.object.company && form.object.company.new_record?
          form.object.build_company(:mandatory => new_company_selected)
        end
        w.div :id => 'new_form', :style => ('display:none;' unless new_company_selected) do
          form.semantic_fields_for :company do |company_form|
            company_fields(company_form, w, 'New Company')
          end
        end
      end
      form.object.company_name ||= form.object.company.name if form.object.company
      form.input :company_name,
        :as           => :autocomplete,
        :label        => 'Company',
        :hint         => 'Start typing to get autocompletion. A Company is required by Section 5001(2)k of the Education Law. ',
        :required     => false,
        :url          => autocomplete_companies_path,
        :wrapper_html => { :style => ('display:none;' if new_company_selected) }
    end
  end

  def company_form_content(form, w)
    company_fields(form, w)
    formtastic_button(form)
  end

  def company_fields(form, w, title=nil)
    form.inputs title do
      form.input :name
      form.input :mandatory, :as => :hidden
      form.input :display_as_client, :as => :boolean
      form.input :url
      form.input :display_with_url, :as => :boolean
      form.input :featured, :as => :boolean
    end
  end

  def admin_form_content(form, w)
    user_form_content(form, w)
  end

  def teacher_form_content(form, w)
    w.errors(form.object)
    form.inputs do
      account_fields(form, w)
      form.input :position, :hint => "position trainers appear at on trainers' bio page" if admin?
      form.input :photo, :required => true, :hint => 'image will be automatically resized to 155x155 format'
      form.object.build_profile unless form.object.profile
      form.semantic_fields_for :profile do |profile|
        profile.inputs do
          profile.input :extra_subjects, :hint => 'comma separated list'
          #profile.input :bio
        end
      end
    end
    formtastic_button(form)
  end

  def login_status(user)
    if user.current_sign_in_at
      "online since #{user.current_sign_in_at.to_s(:short)} (#{user.current_sign_in_ip})"
    elsif user.last_sign_in_at
      "last login at #{user.last_sign_in_at.to_s(:short)} (#{user.last_sign_in_ip})"
    else
      "never logged in"
    end
  end

end
