class Conversation < ActiveRecord::Base
  attr_accessible :title
  
  belongs_to :conversationable, polymorphic: true
  
  has_many :posts 
  has_many :users, :through => :posts
  
  validates :conversationable_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
  
  default_scope order: 'conversations.created_at DESC'
  
end
