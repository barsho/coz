class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy
  

  def create

    @conversation = Conversation.find_by_id(params[:post][:conversation_id])
    @project = @conversation.conversationable
    @conversations = @project.conversations.paginate(page: params[:page])    

    params[:post].delete :conversation_id
    
    
    @post = current_user.posts.build(params[:post])
    
    @post.conversation = @conversation
    
    if @post.save
      flash[:success] = "Post created!"
      redirect_to project_path(@project)
    else
        render  :template => "projects/show", :project => @project
    end
    

  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted!"
    redirect_to project_path(@project)
  end
  
  private

    def correct_user
      @post = current_user.posts.find_by_id(params[:id])
      @project = @post.conversation.conversationable
      redirect_to  project_path(@project) if @post.nil?
    end

end