class UsersController < ApplicationController
  before_action :check_admin

  def show
    if(current_user)
      redirect_to root_path , notice: "You are not authorised" 
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
      end
    end
  end
end
