class Post < ActiveRecord::Base
  attr_accessible :content, :conversation
  
  belongs_to :user
  belongs_to :conversation
  has_one :child_conversation, :class_name => 'Conversation', :as => :conversationable, dependent: :destroy
  has_many :posts, :through => :child_conversation
  
  validates :user_id, presence: true
  validates :conversation_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  before_save :initiate_child_conversation
    
  default_scope order: 'posts.created_at ASC'  
  
  private

    def initiate_child_conversation
      self.create_child_conversation(:title => self.content)
    end
  
end

