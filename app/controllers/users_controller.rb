class UsersController < ApplicationController
  respond_to :html, :json, :xml
  
  before_filter :load_user, :only => [:show, :edit, :destroy]
  
  def index
    respond_with(@users = User.all)
  end

  def show
    respond_with @user
  end

  def new
    @user = User.new
    
    respond_with @user
  end

  def create
    @user = User.new(params[:user])
    
    flash[:notice] = t('users.created', :user => @user) if @user.save
    
    respond_with @user
  end

  def edit
    respond_with @user
  end

  def update
    flash[:notice] = t('users.updated', :user => @user) if @user.update_attributes(params[:user])
    
    respond_with @user
  end

  def destroy
    if @user.id == current_user.id
      return redirect_to @user, :notice => t('users.no_self_destruction')
    else
      @user.destroy
    
      flash[:notice] = t('users.destroyed', :user => @user)
    
      respond_with @user
    end
  end
  
  protected
  
    def load_user
      if params[:id].present?
        @user = User.find(params[:id])
      else
        @user = current_user
      end
    end
  
end
