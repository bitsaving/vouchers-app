class SearchesController < ApplicationController

  def search
    @vouchers = @vouchers.where(id: Voucher.search(Riddle.escape(params[:query]), per_page: 1000)).page(params[:page])
    render :template => 'vouchers/_vouchers' , locals: { :@vouchers=> @vouchers.order(date: :desc) }
  end

end
  