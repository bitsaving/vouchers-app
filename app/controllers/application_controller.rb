class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
<<<<<<< HEAD
  # before_action :authorize
  # def render_404
  #   respond_to do |format|
  #     format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
  #     format.xml  { head :not_found }
  #     format.any  { head :not_found }
  #   end
  # end
 protected
   def authorize    
    redirect_to new_user_session_path, notice: "Please log in" if current_user.nil?
   end
=======

  #FIXME_AB: Why we need this, as rails handles this by itself
  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
 private
   def authorize
      unless current_user
        redirect_to new_user_session_path, notice: "Please log in"
      end
    end
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
end
