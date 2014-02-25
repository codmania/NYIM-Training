class AddFeatured < ActiveRecord::Migration
  def self.up
    add_column :testimonials, :featured, :boolean, :default => 0
    add_index :testimonials, [:featured,:read,:display]
  end

  def self.down
    remove_column :testimonials, :featured
  end
end
