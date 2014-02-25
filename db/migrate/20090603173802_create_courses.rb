class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses, :force => true do |t|
      t.belongs_to :course_group
      t.string  :name
      t.string  :short_name
      t.integer :pos
      t.integer :price
      t.boolean :active
      t.string  :os
      t.integer :hours
      
      t.integer :promotional_discount
      t.integer :promotional_price
      t.datetime :promotion_expires_at
      
      t.timestamps
      
    end
    add_index :courses, :course_group_id
    add_index :courses, :name
  end
  
  def self.down
    drop_table :courses
  end
end
