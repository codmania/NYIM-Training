class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments, :force => true do |t|
      t.string :type #the inheritance column
      t.integer :amount
      t.belongs_to :submitter, :student, :card
      t.datetime :completed_at
      t.boolean :success, :refund
      t.integer :ip 
      t.string :order_id, :limit => 32
      t.string :failed_with
      t.timestamps
    end
    add_index :payments, :type
    add_index :payments, :submitter_id
    add_index :payments, :student_id
    add_index :payments, :completed_at
  end
  
  def self.down
    drop_table :payments
  end
end
