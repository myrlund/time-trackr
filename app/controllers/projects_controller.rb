class ProjectsController < ApplicationController
  respond_to :html, :json, :xml
  
  load_and_authorize_resource
  
  def index
    @projects = current_user.projects
    @projects = @projects.where('title LIKE ?', "%#{params[:q]}%") if params[:q].present?
    respond_with @projects
  end

  def show
    respond_with @project
  end

  def new
    respond_with @project
  end

  def create
    @project = Project.new(params[:project])
    @project.user = current_user
    
    if @project.save
      flash[:notice] = I18n::t('projects.created')
    end
    
    respond_with @project
  end

  def edit
    respond_with @project
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:notice] = I18n::t('projects.updated')
    end
    
    respond_with @project
  end

  def destroy
    @project.destroy
    
    respond_with @project
  end
  
end
