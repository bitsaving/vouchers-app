class OmniAuth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authorize ,only: :google_oauth2
	def google_oauth2
    auth_details = request.env["omniauth.auth"]
    # if Rails.env.production?
    #   user = User.from_omniauth(request.env["omniauth.auth"]) if auth_details.info['email'].split("@")[1] == "vinsol.com"
    # else
       user = User.from_omniauth(request.env["omniauth.auth"])
    # end
    if user && user.persisted?
        flash.notice = user.name + " signed in successfully"
        sign_in_and_redirect user
      # else
        #   session["devise.user_attributes"] = user.attributes
        #   flash.notice = "You are almost Done! Please provide a password to finish setting up your account"
        #   redirect_to new_user_registration_url
    else
      redirect_to new_user_session_path
      flash.notice = "You are not authorized to login. Kindly contact administrator "
    end 
      # else
    #   redirect_to new_user_session_path
    #   flash.notice = "Kindly login through vinsol account"
  end
  
end
