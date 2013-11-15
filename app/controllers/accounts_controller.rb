class AccountsController < ApplicationController

  before_action :set_account, only: [:show, :edit, :update, :destroy] 
  
  def index
    request_type = request.env["HTTP_ACCEPT"].split(',')
    if !request_type.index("text/javascript").nil?
      @accounts = Account.all
    else
      @accounts= Account.all.page(params[:page]).per(50)
    end
    respond_to do |format|
      format.html { }
      format.json { render :json => @accounts.collect {|x| {:label=>x.name, :value=>x.id}}.compact}
      format.js {}
    end
  end


  def new
    @account = Account.new
  end
 
  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    respond_to do |format|
      if @account.save
        format.html { redirect_to accounts_url, notice: 'Account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @voucher }
      else
         format.html { render action: 'new' }
         format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def show 
     respond_to do |format|
     format.js {}
     format.html {}
    end
  end
  
  def update
     respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
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

