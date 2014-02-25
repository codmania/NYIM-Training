class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
      t.belongs_to :feedback
      t.belongs_to :user
      t.text :text
      t.timestamps
    end
    add_index :comments, :feedback_id 
  end

  def self.down
    drop_table :comments
  end
end
