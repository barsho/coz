class Conversation < ActiveRecord::Base
  attr_accessible :title
  
  belongs_to :conversationable, polymorphic: true

  has_many :posts, dependent: :destroy
  has_many :users, :through => :posts
  
  validates :conversationable_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
  
  default_scope order: 'conversations.created_at ASC'
  
  def content_index
    # This is preliminary. See "Following users" for the full implementation.
    @index = ""
    if conversationable_type != "Project" 
      @index += conversationable.conversation.content_index
      @index += "."
      @index += ( conversationable.conversation.posts.index(conversationable) + 1).to_s()
    end

    if conversationable_type == "Project"
      @index += (conversationable.conversations.index(self) + 1 ).to_s()
    end

    
    return @index
  end
  
  
end

