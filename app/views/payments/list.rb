class Views::Payments::List < Application::Widgets::Index
  def widget_content
    h1 'Payments'
    search_and_display_form #if admin?
    super
  end

  def search_and_display_form
    # :display_options => display_options, :search_options => Signup.search
    widget Views::Site::SearchAndDisplayForm, :url => list_payments_path() do |f|
      f.inputs do
        f.object.type_in = Payment::TYPE_NAMES.map(&:camelize) unless f.object.type_in
        f.input :type_in, :label => 'Type', :required => false, :as => :check_boxes,
                :collection      => Payment::TYPE_NAMES.map(&:camelize), :include_blank => false
        f.input :ip, :required => false, :label => 'IP address'
      end
      div :class => 'accordion' do
        h3 { link_to "date", '#', :remote => false }
        div do
          f.inputs do
            f.input :created_at_greater_than,
                    :as => :string, :required => false, :label => 'From',
                    :input_html                   => { 'data-datepicker' => '' }
            f.input :created_at_less_than, :as => :string, :required => false, :label => 'To',
                    :input_html                => { 'data-datepicker' => '' }
          end
        end
        h3 { link_to "users", '#', :remote => false }
        div do
          f.inputs do
            f.input :submitter_email_equals,
                    :as       => :autocomplete,
                    :label    => 'Paid by',
                    :required => false,
                    :hint     => 'Start typing to get autocompletion',
                    :url      => autocomplete_users_path
            f.input :student_email_equals,
                    :as       => :autocomplete,
                    :label    => 'Paid for',
                    :required => false,
                    :hint     => 'Start typing to get autocompletion',
                    :url      => autocomplete_users_path
          end
        end
      end
    end
  end
end
