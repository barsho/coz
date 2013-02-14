module PostsHelper
  def current_user_voted?(post)
    
    
    current_user.votes.each do |vote|
      if vote.post_id == post.id 
        return vote
      end
    end
    
    return false
  end
  
end
