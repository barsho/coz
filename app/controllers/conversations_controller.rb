class ConversationsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy

  def create
    @type = params[:conversation][:conversationable_type]

    if(@type == "Project")
      @conversationable = Project.find(params[:conversation][:conversationable_id])
      params[:conversation].delete( :conversationable_id )
      params[:conversation].delete( :conversationable_type )

      @conversation = @conversationable.conversations.build(params[:conversation])
      @conversations = @conversationable.conversations.paginate(page: params[:page])
      if @conversation.save
        flash[:success] = "Conversation created!"
        @post = current_user.posts.build if signed_in?
      end
      
      respond_to do |format|
        format.js   
      end

#    elsif(@type == "User")
#      @conversationable = User.find(params[:conversation][:conversationable_id])
#      params[:conversation].delete( :conversationable_id )
#      params[:conversation].delete( :conversationable_type )
#      
#      @conversation = @conversationable.build_conversation(params[:conversation])
#      if @conversation.save
#        flash[:success] = "Conversation created!"
#        redirect_to user_path(@conversationable)
#      else
#        redirect_to user_path(@conversationable)
#      end
    end
    
  
  end


  def show
    @conversation = Conversation.find_by_id(params[:id])
    @post = current_user.posts.build if signed_in?
    respond_to do |format|
      format.js   
    end
  end

  def destroy
    @conversation.destroy
    flash[:success] = "Conversation deleted!"
    respond_to do |format|
      format.js
    end
    
  end

  private

    def correct_user
      @conversation = Conversation.find_by_id(params[:id])
      @project = @conversation.conversationable
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
