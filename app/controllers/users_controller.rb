#FIXME_AB: Remove the code which is not required
class UsersController < ApplicationController
   def show
    if(current_user)
      redirect_to waiting_for_approval_vouchers_path 
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
      end
    end
  end
end
