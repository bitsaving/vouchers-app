class Admin::UsersController < ApplicationController
  before_action :set_user, :only => [:edit,:destroy, :update,:show]
  before_action :check_admin
  # GET /users
  # GET /users.json
  def index
    @users = User.all.page(params[:page]).per(10)
     respond_to do |format|
      format.js {}
      format.html{}
    end
  end

  def new
    @user =User.new
  end


  def edit
    # #FIXME_AB: What is before_action :set_user is doing. If you have to find out user again. You are doing the same thing again
    # @user = User.find(params[:id])
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
    if !params[:id]
      #FIXME_AB: Can't you use set_user before action for finding the user. 
      #fixed
      redirect_to waiting_for_approval_vouchers_path
    end
     respond_to do |format|
     format.js {}
     format.html {}
    end
  end

  #FIXME_AB: We are not sure about handling user's destroy. What to do with vouchers assigned to them or created by them etc. So Lets not allow them to be destroyed. Comment this action. Also ensure that user should not be deletable from rails console too. even when I am  doing user.destroy, 
  #fixed
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
    #FIXME_AB: What if user is not found with this ID
    #fixed
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :back
  end
  
  #FIXME_AB: This method should be defined in application controller so that it can be used in any controller as needed.. Like we would be calling it in all admin controllers
   #fixed
end