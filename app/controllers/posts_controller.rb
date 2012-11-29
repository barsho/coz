class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy
  

  def create

    @conversation = Conversation.find_by_id(params[:post][:conversation_id])
    params[:post].delete :conversation_id
    
    if(@conversation.conversationable_type == "Project")
    
      @project = @conversation.conversationable
      @conversations = @project.conversations.paginate(page: params[:page])    
      @post = current_user.posts.build(params[:post])    
      @post.conversation = @conversation
    
      if @post.save
        flash[:success] = "Post created!"
      end
      
      respond_to do |format|
        format.js   
      end
      
    elsif(@conversation.conversationable_type == "User")
      @user = @conversation.conversationable
      @post = current_user.posts.build(params[:post])
      @post.conversation = @conversation
    
      if @post.save
        flash[:success] = "Post created!"
      end
      
      respond_to do |format|
        format.js   
      end
      
    elsif(@conversation.conversationable_type == "Post")
      @post = current_user.posts.build(params[:post])
      @post.conversation = @conversation
      @master = get_master(@conversation) 
      if @post.save
        flash[:success] = "Post created!"
      end
      
      respond_to do |format|
        format.js   
      end
      
    else
    
    end
  end

  def destroy
    flash[:success] = "Post deleted!"
    @post.destroy

    respond_to do |format|
      format.js   
    end

  end
  
  private

    def correct_user
      @post = current_user.posts.find_by_id(params[:id])
    end

    def get_master(conversation)

       @parent = conversation.conversationable
       if (conversation.conversationable_type == 'Post')
         get_master @parent.conversation
       else
         return @parent
       end
     end

end