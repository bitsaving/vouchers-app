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
      #FIXME_AB: Another way to do the same thing is "!!current_user". Ask me if you don't understand
      !current_user.nil?
    end

    def check_admin
      if ! current_user.admin?
        redirect_to "/", flash: { error: "You are not authorized" }
      end
    end

    def redirect_if_no_referer
      redirect_to '/' ,notice: "You are not authorized" unless request.referer
    end

end
