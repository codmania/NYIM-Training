class AddSlugColumnToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :slug, :string
    add_index :courses, :slug, :unique => true
    Course.find_each(&:save)
  end

  def self.down
    remove_column :courses, :slug
  end
end
