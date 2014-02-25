class PaymentsController < ApplicationController

  resourceful_actions :create, :index, :show, :list => :index

  resource_default do |r|
    r.payment_errors = {}
    r.public_payment_errors = {}
    r.submitter        = current_user
    r.ip               = request.ip
    r.transaction_code = cookies['shopping_cart']
    logger.debug "transaction code = #{cookies['shopping_cart'].inspect}"
    r.amount = Money.new(r.custom_amount.to_f * 100) if !r.custom_amount.blank? && admin?
    #logger.debug "cookies = #{cookies.inspect}"
    r.store = cookies
  end

  collection_scope do |scope|
    scope.order('created_at DESC')
  end

  fallback_action :create => [nil, nil, proc { payment_url(resource) }]

  action_component :create do

    logger.info "in action: transaction code = #{cookies['shopping_cart'].inspect}"
    if self.success = resource.save
      test    = !Rails.env.production? && !params[:test].blank?
      success = !params[:success].blank?
      self.success = resource.charge(test, success)
    end
  end

  display_options :submitter, :amount, :created_at, :type, :success, :refund, :ip, :order_id, :failed_with,
                  :only => [:list]

  js :create, :only => true do |page|
    if success
      page.replace_html main_container_dom, render_to_string(:widget => Views::Assets::Asset.new(:resource => 'success'))
      view_context.update_sidebar(page)
    else
      page.replace :new_payment, render_to_string(:widget => Views::Payments::New)
    end
  end

end