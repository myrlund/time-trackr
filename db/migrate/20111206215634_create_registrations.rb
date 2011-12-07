class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.references :project
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration # in seconds
      t.boolean :set_week
      t.boolean :set_day
      t.boolean :set_time

      t.timestamps
    end
    add_index :registrations, :project_id
    add_index :registrations, :user_id
  end
  def self.down
    drop_table :registrations
  end
end
