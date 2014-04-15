class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  
  before_action :authorize

  before_action :get_vouchers_by_year
  skip_before_action :get_vouchers_by_year, only: [:filter_by_year, :authorize]

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
      #FIXME_AB: variable name?
      #fixed
      alert_message = "You are not authorized to view the requested page"
      if request.referer
        redirect_to :back, alert: alert_message
      else
        redirect_to url, alert: alert_message
      end
    end

    def default_tab
      session[:previous_tab] || 'drafted'
    end

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
