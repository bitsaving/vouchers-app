class SearchesController < ApplicationController

  def search
    @vouchers = Voucher.including_accounts_and_transactions.search Riddle.escape(params[:query]), :page => params[:page], :per_page => 5
    render :template => 'vouchers/_vouchers' , locals: { :@vouchers=> @vouchers }
  end

end
  