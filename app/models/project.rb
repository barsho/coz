class Project < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
  has_many :users
  
  has_many :conversations, :as => :conversationable, dependent: :destroy
  has_many :posts, :through => :conversations

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 140 }
  
  default_scope order: 'projects.created_at DESC'
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Conversation.where("conversationable_id = ? AND conversationable_type = ?", id, "Project")
  end
end
