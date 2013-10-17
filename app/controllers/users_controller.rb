class UsersController < ApplicationController
  before_filter :set_user, :only => [:edit,  :update]
    def show
    if(current_user)
      @user = User.find(current_user)
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
      end
    end
  end

  def edit
  end


  protected

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end



end
