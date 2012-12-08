class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :creator_id

      t.timestamps
    end
    add_index :projects, [:creator_id, :created_at]
  end
end
