class CreateTestimonials < ActiveRecord::Migration
  def self.up
    create_table :testimonials do |t|
      t.belongs_to :teacher
      t.belongs_to :course
      t.belongs_to :feedback
      t.text :text
      t.string :name
      t.string :student_info
      t.string :class_info
      t.boolean :display, :read
      t.timestamps
    end
    add_index :testimonials, [:course_id, :display, :read]
    add_index :testimonials, [:teacher_id, :display, :read]
    add_index :testimonials, :feedback_id
  end

  def self.down
    drop_table :testimonials
  end
end
