module TableColumnsHelper

  def assets_column(r, w)
    r.class._assets.each do |asset_name|
      asset = r.send("#{asset_name}_asset")
      if asset
        w.link_to edit_asset_path(asset) do
          w.span "Update #{asset_name}"
        end
      else
        w.link_to new_asset_path(:asset => { :name => r.send("#{asset_name}_asset_name") }) do
          w.span "Add #{asset_name}"
        end
      end
      w.br
      #w.text ' '
    end
  end

  #
  def edit_column(r, w)
    w.link_to 'Edit', edit_polymorphic_path(r)
  end

  def delete_column(r, w)
    w.button_to 'Delete!', polymorphic_path(r), :remote => true, :method => :delete, :class => :inline
  end

  def chechbox_column(r, w, name)
    w.semantic_form_for r, :remote => true do |form|
      form.inputs do
        w.hidden_field_tag :format, :js
        w.hidden_field_tag :no_render, true

        form.input name, :as   => :boolean, :label => '',
          :input_html => { 'data-click-autosubmit' => true,
                           :id                     => dom_id(r, "#{name}_input") }
          end
    end
  end

  [:active, :read, :featured, :display, :invoice_sent, :display_as_client, :display_with_url].each do |column|
    define_method "#{column}_column" do |r, w|
      chechbox_column(r, w, column)
    end
  end

  def _date_column(r, w)
    w.text r.to_s(:short) if r
  end

  [:updated_at, :starts_at, :ends_at, :created_at, :run_at, :locked_at, :failed_at, :started_at, :completed_at].each do |a|
    define_method "#{a}_column" do |r, w|
      _date_column(r.send(a), w)
    end
  end

  def _user_column(r, w, blank='?')
    r ? w.link_to(r.full_name, edit_polymorphic_path(r)) : w.text(blank)
  end

  def retake_column(r, w)
    w.text(!!r.retake?)
  end

  def student_name_column(r, w)
    _user_column(r.student, w)
  end

  [:submitter, :student, :teacher, :created_by, :user].each do |a|
    define_method "#{a}_column" do |r, w|
      args = [r.send(a), w]
      args << 'self' if a == :created_by
      _user_column(*args)
    end
  end

  def user_name_column(r, w)
    _user_column(r, w)
  end

  def photo_column(r, w)
    w.img(:src => r.photo.url(:small), :alt => r.name, :width => '50', :height => '50', :class => 'fltl-left-rounded-corners-shadow')
  end

  def phone_column(r, w)
    w.text r.phone_number ? r.phone_number.to_s : '?'
  end

  def view_column(r, w)
    w.link_to 'Show', polymorphic_path(r)
  end

  def content_column(r, w)
    w.link_to 'Show', polymorphic_path(r, :action => :content), :remote => false, :onclick => "window.open(this.href,'#{r.name}','');return false;"
  end

  def download_column(r, w)
    w.link_to 'Download', polymorphic_path(r, :action => :download), :remote => false
  end

  def company_column(r, w)
    r.company ? w.link_to(r.company.name, polymorphic_path(r.company)) : w.text('?')
  end

  def course_group_column(r, w)
    r.course_group ? w.link_to(r.course_group.name, edit_course_group_path(r.course_group)) : w.text('?')
  end

  def course_column(r, w)
    r.course ? w.link_to(r.course.name, edit_course_path(r.course)) : w.text('?')
  end

  def price_column(r, w)
    w.text money(r.price)
  end

  def amount_column(r, w)
    w.text money(r.amount)
  end

  def promotion_column(r, w)
    if r.promotional?
      w.text r.promotional_price ? money(r.promotional_price) : "#{r.promotional_discount}%"
      w.text " till #{r.promotion_expires_at.to_s(:short)}"
    end
  end

  def seats_available_column(r, w)
    w.div r.show_seats_available, :id => w.helpers.dom_id(r, :seats)
  end

  def manage_seats_column(r, w)
    # we force these to js
    w.button_to '+', polymorphic_path(r, :action => :add_seats), :remote => :true, :method => :put, :class => :inline
    w.text ' '
    w.button_to '-', polymorphic_path(r, :action => :remove_seats), :remote => :true, :method => :put, :class => :inline
    w.text ' '
    w.button_to '!', polymorphic_path(r, :action => :close), :remote => :true, :method => :put, :class => :inline
  end

  def class_column(r, w)
    w.link_to r.name, edit_scheduled_course_path(r.scheduled_course_id) if r.scheduled_course_id
  end

  def feedback_column(r, w)
    w.link_to 'Feedback', edit_feedback_path(r.feedback) if r.feedback
  end

  def job_status_column(r, w)
    status = r.status
    w.div status, :id => w.helpers.dom_id(r, :status)
  end

  def manage_job_column(r, w)
    # we force these to js
    w.button_to 'X', polymorphic_path(r, :action => :fail), :remote => :true, :method => :put, :class => :inline
    w.text ' '
    w.button_to '!', polymorphic_path(r, :action => :restart), :remote => :true, :method => :put, :class => :inline
  end

  def description_column(r, w)
    w.text r.description
  end

  def text_column(r, w)
    w.text truncate(r.text, :length => 20)
  end

  def comment_column(r, w)
    unless r.comments.empty?
      w.text truncate(r.comments.first.text, :length => 10)
      w.text " (#{r.comments.count})"
    end
  end

end
