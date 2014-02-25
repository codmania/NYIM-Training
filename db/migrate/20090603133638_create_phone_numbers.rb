class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers, :force => true do |t|
      t.belongs_to :phoneable, :polymorphic => true
      t.string :country_code, :limit => 3
      t.string :number, :limit => 12
      t.string :extension, :limit => 10
      t.string :type, :limit => 10
      
      t.timestamps
   end
   add_index :phone_numbers, [:phoneable_id, :phoneable_type]
  end

  def self.down
    drop_table :phone_numbers
  end
end
