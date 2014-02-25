class CreateScheduledCourses < ActiveRecord::Migration
  def self.up
    create_table :scheduled_courses, :force => true do |t|
      t.belongs_to :course, :teacher, :location
      t.datetime :starts_at, :ends_at
      t.integer :seats, :seats_available
      t.integer :price
      t.integer :promotional_discount, :promotional_price
      t.datetime :promotion_expires_at
      t.integer :hours
      t.string :os
      t.boolean :active

      t.timestamps
    end
    add_index :scheduled_courses, :course_id
    add_index :scheduled_courses, :teacher_id
    add_index :scheduled_courses, :active
    add_index :scheduled_courses, [:starts_at, :ends_at]
    add_index :scheduled_courses, [:promotion_expires_at,:promotional_discount], :name => 'index_scheduled_courses_on_promotion'
  end

  def self.down
    drop_table :scheduled_courses
  end
end
