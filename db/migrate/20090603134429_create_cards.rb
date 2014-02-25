class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards, :force => true do |t|
      t.string :first_name, :limit => 40
      t.string :last_name, :limit => 40
      t.string :number, :limit => 16
      t.integer :month
      t.integer :year
      t.string :card_type, :limit => 20
      #t.string :verification_value, :limit => 4
      t.belongs_to :student, :address

      t.timestamps
   end
   add_index :cards, :student_id
  end

  def self.down
    drop_table :cards
  end
end
