class AddSlugColumnToScheduledCourses < ActiveRecord::Migration
  def self.up
    add_column :scheduled_courses, :slug, :string
    add_index :scheduled_courses, :slug, :unique => true
    ScheduledCourse.find_each(&:save)
  end

  def self.down
    remove_column :scheduled_courses, :slug
  end

end
