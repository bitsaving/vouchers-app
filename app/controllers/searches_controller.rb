class SearchesController < ApplicationController

  def search
    @vouchers = Voucher.search Riddle.escape(params[:query]), :page => params[:page], :per_page => 5
  
  end

end
  