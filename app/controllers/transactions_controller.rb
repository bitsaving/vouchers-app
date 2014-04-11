class TransactionsController < ApplicationController

before_action :set_transaction, only: [:destroy]


def destroy
    @transaction.destroy 
    redirect_to :back
  end

  def set_transaction
      @transaction = Transaction.find_by(id: params[:id])    
      redirect_to :back if @transaction.nil?
    end
end
