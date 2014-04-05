class AddActiveColumnToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :active, :boolean, :default => 1
    User.update_all ["active = ?", true]
  end

  def self.down
    remove_column :locations, :active
  end
end
