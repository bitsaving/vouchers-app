class Admin::VouchersController < ApplicationController

  def index
    if current_user.user_type == "admin"
      @user = User.find(params[:id])
      @vouchers = Voucher.where(:creator_id => params[:id]).page(params[:page]).per(50)
    else
      redirect_to voucher_path
    end
  end
 
end