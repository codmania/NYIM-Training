class AddInvoiceSentColumnToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :invoice_sent, :boolean
    #Invoice.update_all ["invoice_sent = ?", false]
  end

  def self.down
    remove_column :payments, :invoice_sent
  end
end
