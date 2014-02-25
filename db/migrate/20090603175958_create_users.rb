class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users, :force => true do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      # same_table foreign_key pointing to owner if there is one
      t.belongs_to :parent, :created_by, :company
           
      t.string  :role
     
      t.integer :discount 
      t.boolean :invoiceable

      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
 
    add_index :users, [:role,:created_by_id]
  end

  def self.down
    drop_table :users
  end
end
