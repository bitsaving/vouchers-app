class Admin::UsersController < ApplicationController
  before_action :set_user, :only => [:edit,:destroy, :update]
  
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
    @user = User.find(params[:id])
  end
  # POST /accounts
  # POST /accounts.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: 'user was successfully created.' }
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
        format.html { redirect_to [:admin, @user], notice: 'user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    # else
    #   redirect_to waiting_for_approval_vouchers_path
    end
     respond_to do |format|
     format.js {}
     format.html {}
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url }
      format.json { head :no_content }
    end
  end

  protected
  
  def user_params
    params.require(:user).permit(:first_name,:last_name,:user_type,:email)
  end

  def set_user
    @user = User.find(params[:id])
  end
  
  def check_admin
    if !(current_user.reload.user_type == "admin")
      redirect_to new_user_session_path, flash: { error: "You are not an admin" }
    end
  end
end