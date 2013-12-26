class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  before_action :authorize
  #before_action :set_i18n_locale_from_params

  protected
    
    def authorize    
      redirect_to new_user_session_path, notice: "Please log in" if !logged_in?
    end

    def logged_in?
      !!current_user
    end

    

    def redirect_to_back_or_default_url(url = root_path)
      if request.referer
        redirect_to :back, flash: { error: "You are not authorized to view the requested page" }
      else
        redirect_to url, flash: { error: "You are not authorized to view the requested page" }
      end
    end

    # protected
    # def set_i18n_locale_from_params
    #   if params[:locale]
    #     if I18n.available_locales.include?(params[:locale].to_sym)
    #       I18n.locale = params[:locale]
    #     else
    #       flash.now[:notice] = "#{params[:locale]} translation not available"
    #       logger.error flash.now[:notice]
    #     end
    #   end
    # end
    # def default_url_options
    #   { locale: I18n.locale }
    # end
end
