class RegistrationsController < ApplicationController
  load_and_authorize_resource :project, :except => :create
  load_and_authorize_resource :through => :project, :except => :create
  
  respond_to :html, :json, :xml
  
  def index
    weekview
    
    respond_with(@project, @registrations)
  end
  
  def show
    respond_with [@project, @registration] do |format|
      format.html { redirect_to project_path(@project, :registration_id => @registration.id) }
    end
  end
  
  def new
    respond_with [@project, @registration]
  end
  
  def create
    @registration = Registration.new(params[:registration])
    @registration.user = current_user
    
    if params[:project_id].present?
      # We're at the normal nested route
      @project = Project.find(params[:project_id])
      @registration.project = @project
    else
      # We've posted a "fast registration" to /registrations, and
      # project needs to be extracted from project_title parameter
      @registration.project_title = params[:registration][:project_title]
      @project = @registration.project
    end
    
    # Authorize before altering anything
    authorize! :read, @project
    
    if @registration.save
      flash[:notice] = I18n::t('registrations.created')
    end
    
    respond_with [@project, @registration]
  end
  
  def edit
    respond_with [@project, @registration]
  end
  
  def update
    if @registration.update_attributes(params[:registration])
      flash[:notice] = I18n::t('registration.updated')
    end
    
    respond_with [@project, @registration]
  end
  
  def destroy
    @registration.destroy
    
    respond_with [@project, @registration]
  end
  
  protected
  
    def weekview(delta=0)
      @display = :week
      @registrations = @project.registrations.in_week(Date.today.weeks_ago(-delta))
      
      beginning_of_week = Date.today.beginning_of_week.weeks_ago(-delta)
      @days = []
      7.times { |n| @days << beginning_of_week + n.days }
    end
  
end
