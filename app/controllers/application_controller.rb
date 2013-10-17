class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  private
   def authorize
      unless current_user
        redirect_to new_user_session_path, notice: "Please log in"
      end
    end
end
