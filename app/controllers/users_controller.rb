class UsersController < ApplicationController
  before_action :set_user, :only => [:edit,  :update]

  # GET /users
  # GET /users.json

 def index
  @user = current_user
 end

 #  # GET /users/1/edit
  def edit
  end


def show
    if(current_user)
      @user = User.find(current_user)
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
      end
    end
end

  protected

  def set_user
    @user = current_user
  end
end
