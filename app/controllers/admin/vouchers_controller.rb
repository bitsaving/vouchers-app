class Admin::VouchersController < ApplicationController
  before_action :check_admin  
  before_action :set_user
  def index
    #FIXME_AB: can't we check for admin in before action as we did in users controller. Also look at the comment I put around check_admin method in users controller
    #fixed
      #FIXME_AB: Finding user by id can also be done in the before action
      #fixed
      #FIXME_AB: In other words in the below line you are just finding vouchers of the above user so can't you just use user.vouchers
      #fixed
      @vouchers = @user.vouchers.page(params[:page]).per(50)
  end

  def set_user
    @user =  User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :back
  end
 
end