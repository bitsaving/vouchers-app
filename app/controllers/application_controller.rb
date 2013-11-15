class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  before_action :authorize
 
 protected
   def authorize    
    #FIXME_AB: Instead of checking current_user.nil? make a method logged_in? which returns true/false based on user is logged in or not. In some cases we may also want, This logged_in? method should be a helper method too so that can be used in views
     redirect_to new_user_session_path, notice: "Please log in" if current_user.nil?
   end

end
