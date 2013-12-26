class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  before_action :authorize
  helper_method :get_vouchers
  #before_action :set_i18n_locale_from_params

  protected
    
    def authorize    
      redirect_to new_user_session_path, notice: "Please log in" if !logged_in?
    end

    def logged_in?
      !!current_user
    end

    

    def redirect_to_back_or_default_url(url = root_path)
      #FIXME_AB: You are repeating you flash message twice in this method
      if request.referer
        redirect_to :back, flash: { error: "You are not authorized to view the requested page" }
      else
        redirect_to url, flash: { error: "You are not authorized to view the requested page" }
      end
    end

     def get_vouchers(state)
      @vouchers = Voucher.all

      if params[:account_id]
        @vouchers = @vouchers.by_account(params[:account_id])
        if params[:transaction_type]
          @vouchers = @vouchers.by_transaction_type(params[:transaction_type])
        end
      end

      if params[:user_id] 
        @vouchers = @vouchers.created_by(params[:user_id])
      end

      if params[:tag]
        @vouchers = @vouchers.tagged_with(params[:tag])
      end

      if(params[:to] && params[:from])
        @vouchers = @vouchers.between_dates(params[:from], params[:to])
        filter_by_name_and_type(@vouchers, params[:report_account], params[:transaction_type])
      end

      if state == "drafted"
        @vouchers = @vouchers.created_by(params[:user_id].presence || current_user.id)
      end

      @vouchers = @vouchers.send(state).including_accounts_and_transactions.page(params[:page])
 
    end

    def filter_by_name_and_type(vouchers ,name, type)
      if name.present?
        @vouchers = vouchers.by_account(name)
        @vouchers = @vouchers.by_transaction_type(type) if type.present?
      end
      @vouchers
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
