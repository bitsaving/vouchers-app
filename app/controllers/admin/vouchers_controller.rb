#FIXME_AB: Please check the first line in Admin::UsersController
class Admin::VouchersController < ApplicationController
  before_action :check_admin  
  before_action :set_user

  def index
    @vouchers = @user.vouchers.page(params[:page]).per(50)
  end

  #FIXME_AB: Following method is defined in admin_users_controller too. So if we take AdminBaseController approach then this method can be moved to that controller itself. Check first line in admin_users_controller.rb
  def set_user
    @user =  User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :back
  end
 
end