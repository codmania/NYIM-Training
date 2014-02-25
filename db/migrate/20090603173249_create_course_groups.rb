class CreateCourseGroups < ActiveRecord::Migration
  def self.up
    create_table :course_groups, :force => true do |t|
      t.string  :name
      t.string  :short_name
      t.integer :pos
      t.boolean :active
      t.timestamps
    end
    add_index :course_groups, :pos
  end

  def self.down
    drop_table :course_groups
  end
end
