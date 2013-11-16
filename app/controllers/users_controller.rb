#FIXME_AB: Remove the code which is not required
class UsersController < ApplicationController
  # before_action :set_user, :only => [:show]
  
  # include CurrentUser
  # 

  # GET /users
  # GET /users.json

#  def index
#   @users = User.all
#  end
#  def new
#   @user =User.new
# end
 
  # POST /accounts
  # POST /accounts.json
  # def create
  #   @user = User.new(user_params)
  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'account was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @voucher }
  #     else
  #        format.html { render action: 'new' }
  #        format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # def update
  #   respond_to do |format|
  #     if @user.update(user_params)
  #       format.html { redirect_to @user, notice: 'Product was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end


 # #  # GET /users/1/edit
 #  def edit
 #    #  # if(!(admin?(current_user)))
 #    #   redirect_to @user, notice: "No editing privileges for you"
 #    # end
   
 #  end


  def show
    if(current_user)
     #  @user = current_user
     # # respond_to do |format|
     # #    format.html {}
     # #  end
      redirect_to waiting_for_approval_vouchers_path 
      # end
      else
        respond_to do |format|
          format.html { redirect_to new_user_session_path }
        end
      end
  end

  # protected
  # def user_params
  #   params.require(:user).permit(:first_name,:last_name,:user_type,:email)
  # end

  # def set_user
  #   if admin?(current_user)
  #     @user = User.find(params[:id])
  #   else
  #     @user = current_user
  #   end
  # end
end
