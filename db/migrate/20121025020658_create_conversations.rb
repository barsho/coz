class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :title
      t.integer :conversationable_id
      t.string  :conversationable_type

      t.timestamps
    end
    add_index :conversations, [:conversationable_id, :created_at]
  end
end
