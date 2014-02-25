class AddSlugColumnToCourseGroups < ActiveRecord::Migration
  def self.up
    add_column :course_groups, :slug, :string
    add_index :course_groups, :slug, :unique => true
    CourseGroup.find_each(&:save)
  end

  def self.down
    remove_column :course_groups, :slug
    end
end
