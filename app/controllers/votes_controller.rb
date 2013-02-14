class VotesController < ApplicationController
  before_filter :signed_in_user, only: [:create, :show]
  before_filter :correct_user,   only: :destroy
  

  def create

    @post = Post.find_by_id(params[:post_id])
    params.delete :post_id
 
    current_user.votes.each do |vote|
      if vote.post_id == @post.id 
        vote.destroy
      end
    end
    
    @vote = current_user.votes.build(value: params[:value])
    @vote.post = @post
    @vote.save
    respond_to do |format|
      format.js   
    end
      
  end


  
  private

    def correct_user
      @post = current_user.posts.find_by_id(params[:id])
    end



end