class CommentsController < ApplicationController
  before_action :set_transaction, only: [:destroy]

  def create
    @voucher = Voucher.find(params[:voucher_id])
    if(@voucher.nil?)  
      flash[:notice] = "Voucher not found"
      redirect_to :back
      return false
    end
    @transaction = @voucher.transactions.build(transaction_params)
    if(@transaction.save)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js {}
      end
    else
      respond_to do |format|
        format.html do
          redirect_to :back
        end
        format.js do
        end
      end
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @transaction = Transaction.find_by(id: params[:id])
    if(@transaction.nil?)  
        #flash[:notice] = " not found"
        redirect_to_back_or_default_url
      end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.permit(:account_id ,:amount , :account_type, :voucher_id)
  end
end