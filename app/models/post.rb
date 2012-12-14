class Post < ActiveRecord::Base
  attr_accessible :content, :conversation
  
  belongs_to :user
  belongs_to :conversation
  has_one :child_conversation, :class_name => 'Conversation', :as => :conversationable, dependent: :destroy
  has_many :posts, :through => :child_conversation
  
  validates :user_id, presence: true
  validates :conversation_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  default_scope order: 'posts.created_at ASC'  
  
  def cumulative_post_count
    # This is preliminary. See "Following users" for the full implementation.
    @sum = 0
    if child_conversation.posts.count != 0
      child_conversation.posts.each do |post|
        @sum += post.cumulative_post_count
      end
      @sum += child_conversation.posts.count
    end
    
		return @sum
  end
  

  
  
end

