class CreateScheduledSessions < ActiveRecord::Migration
  def self.up
    create_table :scheduled_sessions, :force => true do |t|
      t.datetime   :starts_at
      t.datetime   :ends_at
      t.belongs_to :scheduled_course
      t.boolean    :active
      t.integer    :duration
      t.timestamps
    end
    add_index :scheduled_sessions, :scheduled_course_id
    add_index :scheduled_sessions, :starts_at
  end

  def self.down
    drop_table :scheduled_sessions
  end
end
