class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  before_action :authorize
  protected
    def authorize    
      redirect_to new_user_session_path, notice: "Please log in" if !logged_in?
    end

    def logged_in?
      !!current_user
    end

    def check_admin
      if ! current_user.admin?
        redirect_to "/", flash: { error: "You are not authorized to view the requested page" }
      end
    end

    def redirect_to_back_or_default_url(url = root_path)
      if request.referer
        redirect_to :back, flash: { error: "You are not authorized to view the requested page" }
      else
        redirect_to url , flash: { error: "You are not authorized to view the requested page" }
      end
    end
end
