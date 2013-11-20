#FIXME_AB: Formatting issues
class OmniAuth::SessionsController < Devise::SessionsController
   skip_before_action :authorize
   # before_action only: [:create] ,on: [:destroy] do
   # 	flash[:notice]="lol"
   # end
   before_action only: [:new] do
   	flash[:notice]= nil
   end

  # before_action only: [:new] do
	 # flash[:notice] = nil
	 # #flash[:notice] = nil
  #  end



  #  def destroy
  #   flash[:notice] = "Signed out successfully"
  # end

end