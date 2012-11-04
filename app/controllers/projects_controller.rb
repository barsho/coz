class ProjectsController < ApplicationController
  
  def new
    @project = Project.new
  end
  
  def create
    @project = current_user.projects.build(params[:project])
    if @project.save
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
    @conversation = @project.conversations.build
  end
  
  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:success] = "Project updated"
      redirect_to @project
    else
      render 'edit'
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @user = @project.user
    @project.destroy
    flash[:success] = "Project destroyed."
    redirect_to @user
  end
  
  def index
    @projects = Project.paginate(page: params[:page])
  end
  
end
