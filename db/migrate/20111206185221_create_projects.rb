class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :title
      t.string :url
      t.text :description
      
      t.references :user
      
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
