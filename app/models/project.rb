class Project < ActiveRecord::Base
  attr_accessible :name, :creator
  belongs_to :creator, :class_name => 'User', :foreign_key => "creator_id"
  has_and_belongs_to_many :users
  
  has_many :conversations, :as => :conversationable, dependent: :destroy
  has_many :posts, :through => :conversations


  validates :name, presence: true, length: { maximum: 140 }
  
  default_scope order: 'projects.created_at DESC'
  
  def cumulative_post_count
    # This is preliminary. See "Following users" for the full implementation.
    @sum = 0
    conversations.each do |conversation|
      if conversation.posts.count != 0
        conversation.posts.each do |post|
          @sum += post.cumulative_post_count
        end
        @sum += conversation.posts.count
      end
    end
		return @sum
  end
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Conversation.where("conversationable_id = ? AND conversationable_type = ?", id, "Project")
  end
end
