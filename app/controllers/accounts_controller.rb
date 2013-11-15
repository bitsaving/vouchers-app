class AccountsController < ApplicationController

  before_action :set_account, only: [:show, :edit, :update, :destroy] 
  
  def index
    #FIXME_AB: Why are you just using first 50 records. In auto complete my account will not be displayed if it is the 51th record
    @accounts= Account.all.page(params[:page]).per(50)
    
    respond_to do |format|
      format.html { }
      #FIXME_AB: formatting issues
      format.json { render :json => @accounts.collect {|x| {:label=>x.name, :value=>x.id}}.compact}
      #FIXME_AB: DO we need this format.js?
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
        #FIXME_AB: Modify flash message "Account 'account name' was successfully created."
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
      #FIXME_AB: no {} needed
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
    #FIXME_AB: We don't need to destroy the account so remove thsi action. also make sure account should not be deletable if I do account.destroy
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
      #FIXME_AB: What if account is not found?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name)
    end 
 end

