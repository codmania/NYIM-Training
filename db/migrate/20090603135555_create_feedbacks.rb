class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    
    create_table :feedbacks, :force => true do |t|
      t.belongs_to :scheduled_course
      t.text :text
      t.boolean :display, :read
      
      t.text  :general, :most_useful, :least_useful
      t.integer :knowledge, :patience, :location, :cleanliness, :materials
      t.text :how_to_improve, :why_nyim
      t.boolean :recommend, :reference
      
      t.timestamps
      
    end
    add_index :feedbacks, :scheduled_course_id
    add_index :feedbacks, :display 
    add_index :feedbacks, :read
  end
  
  def self.down
    drop_table :feedbacks
  end
end
