class Api::VouchersController < ApplicationController
  respond_to :json, :xml

  before_action :authorize

  def index
    @vouchers = Voucher.all
    respond_with @vouchers
  end

  def show
    @voucher = Voucher.first
    respond_with @voucher
  end

  private

  def authorize
    #respond_with({}) unless (params[:consumer_key] = 'admin' && params[:consumer_secret] == 'vinsol')
  end
end