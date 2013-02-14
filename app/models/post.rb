# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  content         :string(255)
#  user_id         :integer
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Post < ActiveRecord::Base
  attr_accessible :content, :conversation
  
  belongs_to :user
  belongs_to :conversation
  has_one :child_conversation, :class_name => 'Conversation', :as => :conversationable, dependent: :destroy
  has_many :posts, :through => :child_conversation
  has_many :votes
  
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
  
  def cumulative_vote_count
    # This is preliminary. See "Following users" for the full implementation.
    @sum = 0
    if child_conversation.posts.count != 0
      child_conversation.posts.each do |post|
        @sum += post.cumulative_vote_count
      end
      @sum += self.votes.count
    end
    
		return @sum
  end
  
  def vote_sum
    # This is preliminary. See "Following users" for the full implementation.
    @sum = 0
    if self.votes.count != 0
      self.votes.each do |vote|
        @sum += vote.value
      end
    end
    
		return @sum
  end
  
  
  def cumulative_vote_sum
    # This is preliminary. See "Following users" for the full implementation.
    @sum = 0
    if child_conversation.posts.count != 0
      child_conversation.posts.each do |post|
        @sum += post.cumulative_vote_sum
      end
      @sum += self.vote_sum
    end
    
		return @sum
  end
  
  def vote_distribution
    @distribution = []
    @p3 = 0
    @p2 = 0
    @p1 = 0
    @n1 = 0
    @n2 = 0
    @n3 = 0
    
    self.votes.each do |vote|
      if vote.value == 3
        @p3 += 1
        @p2 += 1
        @p1 += 1
      elsif vote.value == 2
        @p2 += 1
        @p1 += 1
      elsif vote.value == 1
        @p1 += 1
      elsif vote.value == -1
        @n1 += 1
      elsif vote.value == -2
        @n1 += 1
        @n2 += 1
      elsif vote.value == -3
        @n1 += 1
        @n2 += 1
        @n3 += 1
      end
    end
    @distribution << @p3
    @distribution << @p2
    @distribution << @p1
    @distribution << @n1
    @distribution << @n2
    @distribution << @n3


    return @distribution
  end
  
end

