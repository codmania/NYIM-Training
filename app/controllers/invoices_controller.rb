class InvoicesController < ApplicationController

  resourceful_actions :update, :list => :index

  display_options :submitter, :amount, :created_at, :ip, :order_id, :invoice_sent, :only => [:list]

end