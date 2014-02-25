class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies, :force => true do |t|
      t.string :name, :limit => 40
      t.string :url, :limit => 100 
      t.boolean :display_with_url, :display_as_client, :featured
      t.integer :pos
      t.timestamps
    end
    add_index :companies, [:featured,:name]
    add_index :companies, :name
  end
  
  def self.down
    drop_table :companies
  end
end
