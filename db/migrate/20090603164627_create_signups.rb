class CreateSignups < ActiveRecord::Migration
  def self.up
    create_table :signups, :force => true do |t|
      t.belongs_to :course, :scheduled_course, :student, :submitter, :created_by, :feedback
      t.belongs_to :payment #this is single table inheritance so 
      t.integer :price
      t.string :transaction_code
      t.text :discount_description
      t.datetime :confirmed_at
      t.string :status
      t.string  :os   # student preference for subscription
      t.boolean :certificate_to_be_mailed
      t.boolean :purchase_type
      t.datetime :certificate_mailed_on
      t.timestamps
    end
    add_index :signups, [:status,:purchase_type]
    add_index :signups, :scheduled_course_id
    add_index :signups, :student_id
    add_index :signups, :submitter_id
    add_index :signups, :created_by_id
    # signup is never searched from feedback or course
  end
  
  def self.down
    drop_table :signups
  end
end
