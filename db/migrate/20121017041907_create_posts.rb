class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :user_id
      t.integer :conversation_id  
      t.integer :type
      t.timestamps
    end
    
    add_index :posts, [:user_id, :conversation_id, :type, :created_at]

  end
end
