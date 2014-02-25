class CreateFailedPaymentsPurchases < ActiveRecord::Migration
  def self.up
    create_table :failed_payments_purchases,  :id=> false, :force => true do |t|
      t.belongs_to :signup, :payment
    end
    add_index :failed_payments_purchases, :payment_id
  end
  
  def self.down
    drop_table :failed_payments_purchases
  end
end
