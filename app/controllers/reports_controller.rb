class ReportsController < VouchersController
  before_action :check_validity, only: [:generate_report]
  before_action :convert_date, only: [:generate_report]
  before_action :default_tab, only: [:report]
  
  def report 
    params[:from] = Date.today.beginning_of_month()
    params[:to] = Date.today.end_of_month()
    @vouchers = Voucher.between_dates(params[:from], params[:to]).send(session[:previous_tab]).page(params[:page])
    render  :template => 'vouchers/index', locals: {:@vouchers => @vouchers}
  end

  #FIXME_AB: better if we have this named as generate. So that we can call it by /reports/generate?to=
  def generate
    @start_date = params[:from]
    @end_date = params[:to]
    @account_name = params[:account_id]
    @transaction_type = params[:transaction_type]
  end


  protected
    def convert_date
      params[:from] = params[:from].to_date
      #FIXME_AB: what if param[:to] is nil?
      params[:to] = params[:to].to_date
    end

    def check_validity
      if params[:from].nil? || params[:to].nil? || params[:from] > params[:to]
        redirect_to report_path, notice: "PLease enter valid values!!"
      end
    end

    def default_tab
      session[:previous_tab] || 'drafted'
    end
end