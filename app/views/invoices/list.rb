class Views::Invoices::List < Application::Widgets::Index
  def widget_content
    h1 'Payments'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm, :url => list_invoices_path() do |f|
      f.inputs do
        f.object.invoice_sent_in ||= [true, false]
        f.input :invoice_sent_in, :label => 'Invoice sent', :as => :check_boxes, :collection => boolean_collection,
                :member_label => proc { |x| yesno(x) }, :required => false
        f.input :ip, :required => false, :label => 'IP address'
        f.input :created_at_greater_than,
                :as => :string, :required => false, :label => 'From',
                :input_html => {'data-datepicker' => ''}
        f.input :created_at_less_than, :as => :string, :required => false, :label => 'To',
                :input_html => {'data-datepicker' => ''}
        f.input :submitter_email_equals,
                :as => :autocomplete,
                :label => 'Paid by',
                :required => false,
                :hint => 'Start typing to get autocompletion',
                :url => autocomplete_users_path
        f.input :student_email_equals,
                :as => :autocomplete,
                :label => 'Paid for',
                :required => false,
                :hint => 'Start typing to get autocompletion',
                :url => autocomplete_users_path
      end
    end
  end
end
