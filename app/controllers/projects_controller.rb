class ProjectsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :edit, :update]
  before_filter :project_owner,   only: [:edit, :update, :destroy]  
  
  def new
    @project = Project.new
  end
  
  def create
    @project = current_user.projects.build(params[:project])


    if @project.save
   #   @project.create_info_conversation(title: @project.name)
      @project.users << current_user
      
      @project.conversations.create(title: "Index")
      @project.conversations.create(title: "Team")
      @project.conversations.create(title: "Tickets")
      @project.conversations.create(title: "Calendar")
      @project.conversations.create(title: "Statistics")
      @project.conversations.create(title: "Whiteboard")
    
    
                  
      flash[:success] = "Project created!"
      redirect_to @project
    else
      @feed_items = []
      render 'new'
    end
  end
  
  def show
    @project = Project.find(params[:id])
    @conversations = @project.feed.paginate(page: params[:page])    
    @conversation = @project.conversations.build if signed_in?
    @post = current_user.posts.build if signed_in?
  end
  
 
 
  def edit
  end
  

  
  def update
    if @project.update_attributes(params[:project])
      flash[:success] = "Project updated"
      redirect_to @project
    else
      render 'edit'
    end
  end
  
  def destroy
    @project.destroy
    flash[:success] = "Project destroyed."
    redirect_to @user
  end
  
  def index
    @projects = Project.paginate(page: params[:page])
  end
  
  def project_owner
    @project = Project.find(params[:id])
    @user = @project.users[0]
    
    redirect_to(@project) unless current_user?(@user)
  end
  
end
