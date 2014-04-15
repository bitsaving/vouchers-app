class ReportsController < VouchersController
  
  before_action :check_validity, only: [:generate]
  before_action :convert_date, only: [:generate]
  before_action :set_params, only: [:report]
  before_action :default_tab, only: [:report]
  
  
  def report   
    render  action: 'index' 
  end

  #FIXME_AB: better if we have this named as generate. So that we can call it by /reports/generate?to=
  #fixed
  def generate
  end


  protected

    def convert_date
      if params[:from] && params[:to]
        params[:from] = params[:from].to_date
        params[:to] = params[:to].to_date
      end
    end

    def check_validity
      if params[:from].nil? || params[:to].nil? || params[:from].to_date > params[:to].to_date
        redirect_to report_path, notice: "PLease enter valid values!!"
      end
    end

    def set_params
      params[:from] = session[:start_date] || Date.today.beginning_of_month()
      params[:to] = session[:end_date] || Date.today.end_of_month()
      @vouchers = @vouchers.including_accounts_and_transactions.between_dates(params[:from], params[:to]).send(default_tab).page(params[:page])
      @vouchers = @vouchers.created_by(current_user.id) if default_tab == "drafted"
      @vouchers_all = @vouchers.including_accounts_and_transactions.between_dates(params[:from], params[:to]).page(params[:page])
      @vouchers_all = @vouchers_all.created_by(current_user.id) if default_tab == "drafted"
    end  

end