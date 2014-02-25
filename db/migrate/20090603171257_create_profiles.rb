class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles, :force => true do |t|
      t.belongs_to :teacher
      t.string  :extra_subjects, :limit => 200
      t.text  :bio
      t.timestamps
    end
    add_index :profiles, :teacher_id
  end

  def self.down
    drop_table :profiles
  end
end
