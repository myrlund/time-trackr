class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user_session, :current_user
  
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to request.referer || root_url, :error => I18n::translate("auth.not_authorized")
    else
      redirect_to new_user_session_path(:next => request.path), :error => I18n::translate("auth.authentication_required")
    end
  end
  
  private
  
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user
      end

end
