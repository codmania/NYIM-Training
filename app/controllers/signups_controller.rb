class SignupsController < ApplicationController
  # this is very very dangerous surely
  #include ActiveModel::StateMachine::StatedController
  layout :layout

  def layout
    action_name == 'disclose_certificate' ? 'certificate' : 'nyim'
  end

  display_options :student, :class, :status, :created_at, :price, :submitter, :created_by, :os, :feedback,
                  :only => [:list, :show]

  resource_default do |r|
    # this assigns any signups by default to the current user if they're a student and already logged in
    r.student_email = nil if default_student && r.student_email == default_student.full_name_with_email
    r.student_id ||= default_student.id if default_student && !r.has_new_student?
    r.submitter_id ||= current_student_id if admin?
    r.created_by ||= current_user
    r.updated_by = current_user unless r.new_record?
  end

  resourceful_actions :defaults,
                      :reschedule_update => :update,
                      :shopping_cart => :index,
                      :disclose_certificate => :show,
                      :reschedule => :edit,
                      :certificate => :show,
                      :feedback => :edit,
                      :feedback_update => :update,
                      :save_for_later => :update,
                      :add_to_shopping_cart => :update,
                      :forget => :update,
                      :list => :index

  js :shopping_cart do |page|
    page.replace 'sidebar', render_to_string(:widget => Views::Site::UserPanel)
  end

  js :create, :update, :reschedule, :reschedule_update, :feedback_update do |page|
    view_context.update_sidebar(page)

    page.replace 'header', render_to_string(:widget => Views::Site::NyimHeader) if @newly_signed_in

  end

  js :add_to_shopping_cart, :save_for_later, :forget, :only => true do |page|
    view_context.update_sidebar(page)


  end

  collection_scope do |scope|
    scope.order('created_at DESC')
  end

  action_component :reschedule do
    #resource.rescheduled_course_id = 0
  end

  action_component :create do
    if self.success = resource.save
      @newly_signed_in = sign_in :user, resource.student unless signed_in?
      session[:student] ||= resource.student.id # this will set submitter to student if it was admin
    end
  end

  # this is tolerant to item already deleted
  action_component :forget do
    self.success = (resource.forget rescue true)
  end

  action_component :reschedule_update do
    resource.reconfirm if resource.can_reconfirm?
    self.success = resource.cancel
  end

  action_component :add_to_shopping_cart do
    self.success = resource.add_to_shopping_cart
  end

  action_component :save_for_later do
    self.success = resource.save_for_later
  end

  action_component :feedback_update do
    self.success = resource.complete || admin? && resource.save
  end

  action_component :shopping_cart do
    checkout
  end

  def get_student
    @student ||= Student.find_by_slug(params[:student])
  end

  collection_scope :shopping_cart do |scope|
    if current_user
      student_id = get_student.ifnil?(&:id)
      scope.shopping_cart(student_id || current_user.id).limit(1000).readonly(false)
    else
      scope
    end
  end

  def checkout
    student_id = get_student.ifnil?(&:id)
    @payment = Payment.new(:amount => Money.new(0),
                           :student_id => student_id,
                           :submitter => current_user,
                           :store => cookies
    )

    transaction_code = @payment.order_id
    cookies['shopping_cart'] = {:expires => site(:payment_timeout_interval).seconds.from_now,
                                :value => transaction_code}
    logger.info "transaction code cookie set to #{cookies['shopping_cart'].inspect}"

    Signup.transaction do
      resource do |c|
        c.check_out
        c.transaction_code = transaction_code
        @payment.amount += c.price!
        c.save!
      end
    end

    NyimJobs::ExpireShoppingCart.new(:ids => resource.map(&:id), :transaction_code => transaction_code).
        launch(site(:payment_timeout_interval).seconds.from_now)
  end

end
