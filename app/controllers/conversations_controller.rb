class ConversationsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy

  def create
    @project = Project.find(params[:conversation][:conversationable_id])
    params[:conversation].delete :conversationable_id
    @conversation = @project.conversations.build(params[:conversation])
    @conversations = @project.conversations.paginate(page: params[:page])    
    
    if @conversation.save
      flash[:success] = "Conversation created!"
      redirect_to project_path(@project)
    else
      
      render  :template => "projects/show", :project => @project  
    end        
  end


  def destroy
    @conversation.destroy
    flash[:success] = "Conversation deleted!"
    redirect_to project_path(@project)
  end

  private

    def correct_user
      @conversation = Conversation.find_by_id(params[:id])
      @project = @conversation.conversationable
      redirect_to project_path(@project) if @conversation.nil?
    end

end
