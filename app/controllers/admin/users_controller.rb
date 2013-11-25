#FIXME_AB: One good approach for admin controllers is you define a AdminBaseController which is inherited from ApplicationController like you have done below. And inherited all you admin controllers form this AdminBaseController. This way if we have to do some common thing for all admin controllers, we can do it by doing in AdminBaseController. We can discuss F2F if it is not clear. 

class Admin::UsersController < ApplicationController
  before_action :set_user, :only => [:edit,:destroy, :update,:show]
  #FIXME_AB: Following before_action can be moved to AdminBaseController if we follow the approach I mentioned in the first line of this file
  before_action :check_admin
  before_action :redirect_if_logged_in_first_time ,:only => [:show]
  # GET /users
  # GET /users.json
  def index
    #FIXME_AB: Lets make per page = 50
    @users = User.all.order('first_name').page(params[:page]).per(5)
     respond_to do |format|
      format.js {}
      format.html{}
    end
  end

  def new
    @user =User.new
  end

  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: @user.name + ' was successfully created.' }
        format.json { render action: 'show', status: :created, location: @voucher }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to [:admin, @user], notice: @user.name + ' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    
     respond_to do |format|
     format.js {}
     format.html {}
    end
  end

  # def destroy
  #   begin
  #     @user.destroy
  #     flash[:notice] = "User #{@user.name} deleted"
  #     rescue Exception => e
  #     flash[:notice] = e.message
  #   end
  #   respond_to do |format|
  #     format.html { redirect_to admin_users_url }
  #     format.json { head :no_content }
  #   end
  # end
  protected
  
  def user_params
    params.require(:user).permit(:first_name,:last_name,:user_type,:email)
  end

  def set_user
    @user = User.find(params[:id])
    #FIXME_AB: Instead of handling this exception you should check for user.nil?
    rescue ActiveRecord::RecordNotFound
      redirect_to :back
  end
  

  def redirect_if_logged_in_first_time 
    if !params[:id]
      #FIXME_AB: This redirection should be done from the before filter itself
      redirect_to assigned_vouchers_path
    end
  end


end