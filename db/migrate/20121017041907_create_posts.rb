class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :user_id
      t.integer :conversation_id  
      t.integer :relative_id  
      
      t.timestamps
    end
    
    add_index :posts, [:user_id, :conversation_id, :created_at]
    add_index :posts, [:relative_id]
  end
end
