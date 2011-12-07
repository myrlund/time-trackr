class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    
    @user_session.save do |result|
      if result
        redirect_to account_url
      else
        render :action => :new
      end
    end
  end

  def destroy
    current_user_session.destroy
    
    redirect_to new_user_session_url
  end
end