class OmniAuth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
    auth_details = request.env["omniauth.auth"]
    if auth_details.info['email'].split("@")[1] == "vinsol.com"
      user = User.from_omniauth(request.env["omniauth.auth"])
      if user.persisted?
        flash.alert = "Signed in Through Vinsol!"
        sign_in_and_redirect user
      else
        session["devise.user_attributes"] = user.attributes
        flash.notice = "You are almost Done! Please provide a password to finish setting up your account"
        redirect_to new_user_registration_url
      end
    else
      redirect_to new_user_session_path
      flash.notice = "Kindly login through vinsol account"
    end
  end
  
end
