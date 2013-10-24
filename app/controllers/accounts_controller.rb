class AccountsController < ApplicationController
  before_action :authorize
  before_action :set_account, only: [:show, :edit, :update, :destroy]	
  def index  
    @accounts= Account.all
    render :json => @accounts.collect {|x| {:label=>x.name, :value=>x.id}}.compact
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /vouchers/new
  def new   
    @account = Account.new
  end

  # GET /vouchers/1/edit
  def edit  
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    respond_to do |format|
      if @account.save
        format.html { redirect_to :back, notice: 'account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @voucher }
      else
         format.html { render action: 'new' }
         format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  protected
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name)
    end 
 end

