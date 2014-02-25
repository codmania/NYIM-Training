class AddSlugColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :slug, :string
    add_index :users, :slug, :unique => true
    User.find_each(&:save)
  end

  def self.down
    remove_column :users, :slug
  end
end
