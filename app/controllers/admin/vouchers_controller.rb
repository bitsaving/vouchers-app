class Admin::VouchersController < ApplicationController

  def index
    #FIXME_AB: can't we check for admin in before action as we did in users controller. Also look at the comment I put around check_admin method in users controller
    if current_user.user_type == "admin"
      #FIXME_AB: Finding user by id can also be done in the before action
      @user = User.find(params[:id])
      #FIXME_AB: In other words in the below line you are just finding vouchers of the above user so can't you just use user.vouchers
      @vouchers = Voucher.where(:creator_id => params[:id]).page(params[:page]).per(50)
    else
      #FIXME_AB: voucher_path or vouchers_path
      redirect_to voucher_path
    end
  end
 
end