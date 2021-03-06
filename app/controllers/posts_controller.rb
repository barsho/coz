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
        @post.type = 0
        @post.create_child_conversation( title: @post.content)
        if @project.users.include?(current_user) == false
          @project.users << current_user
        end 

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
        @post.create_child_conversation( title: @post.content)
        if @master.users.include?(current_user) == false
         @master.users << current_user
       end
        
        flash[:success] = "Post created!"
      end
      
      respond_to do |format|
        format.js   
      end
      
    else
    
    end
  end

  def move

    @drag_post = Post.find_by_id(params[:id])
    @drag_post_conversation = @drag_post.conversation
    
    @drop_conversation = Conversation.find_by_id(params[:drop_id])
    



    @drop_conversation.posts << @drag_post
    @drop_conversation.save
    
    @drag_post.conversation = @drop_conversation
    @drag_post.save

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