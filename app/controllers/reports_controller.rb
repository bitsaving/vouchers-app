class ReportsController < ApplicationController
  before_action :convert_date, only: [:generate_report]
  def report 
    params[:from]  = Date.today.beginning_of_month()
    params[:to]  = Date.today.end_of_month()
  end

  #FIXME_AB: I think we should have separate controller for reporting.
  def generate_report
    #FIXME_AB: What about params[:to]
    if params[:from].nil?
      redirect_to report_path
    elsif params[:from].present? && params[:from] > params[:to]
      #FIXME_AB: What are valid values, can we be more precise 
      redirect_to report_path , notice: "From date cannot be greator than to date"
    end
    @voucher_startDate = params[:from]
    @voucher_endDate = params[:to]
    @voucher_accountName = params[:report_account]
    @voucher_accountType = params[:account_type]
  end


  protected

   def convert_date
      # if params[:from]
        params[:from] = params[:from].presence.to_date
        #FIXME_AB: what if param[:to] is nil?
        params[:to] = params[:to].presence.to_date
      # end
    end
end