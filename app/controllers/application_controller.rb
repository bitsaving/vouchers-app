class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  
  before_action :store_location
  before_action :authorize

  before_action :get_vouchers_by_year
  skip_before_action :get_vouchers_by_year, only: [:filter_by_year, :authorize]


  def store_location
    if current_path_useful? 
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    previous_or_root_path
  end

  def after_sign_out_path_for(resource)
    previous_or_root_path
  end

  def after_sign_up_path_for(resource)
    previous_or_root_path
  end

  def previous_or_root_path

    session[:previous_url] || root_path
  end
  def after_confirmation_path_for(resource_name, resource)
    previous_or_root_path
  end

 
  def current_path_useful?
    request_path = request.fullpath unless request.fullpath =~ /user/  || request.post? || request.xhr? # don't store ajax calls
    request_path
  end

  def filter_by_year
    session[:date] = params[:year]   
    redirect_to :back if params[:year].present?
  end

  def get_vouchers_by_year
    session[:date] = session[:date] || populate_dropdown[0][1]
    date = session[:date].split("->")
    session[:start_date] =date[0].to_date
    session[:end_date] = date[1].to_date
    @vouchers = Voucher.between_dates(session[:start_date], session[:end_date])
  end
    
  def authorize    
    redirect_to new_user_session_path, notice: "Please log in" if !logged_in?
  end

    def logged_in?
      !!current_user
    end

    def redirect_to_back_or_default_url(url = root_path)
      alert_message = "You are not authorized to view the requested page"
      if request.referer && !(request.referer =~ /user/)
        redirect_to :back, alert: alert_message
      else
        redirect_to url, alert: alert_message
      end
    end

    def default_tab
      session[:previous_tab] || 'drafted'
    end

    helper_method :default_tab
 protected
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
