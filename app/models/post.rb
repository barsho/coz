class Post < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  belongs_to :conversation
  has_one :conversation, :as => :conversationable
  has_many :posts, :through => :conversation
  
  validates :user_id, presence: true
  validates :conversation_id, presence: true
    
end
