class Post < ActiveRecord::Base
  attr_accessible :content, :conversation
  
  belongs_to :user
  belongs_to :conversation
  has_one :child_conversation, :class_name => 'Conversation', :foreign_key => 'relative_id'
  has_many :posts, :through => :child_conversation
  
  validates :user_id, presence: true
  validates :conversation_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
    
  default_scope order: 'posts.created_at DESC'  
end

