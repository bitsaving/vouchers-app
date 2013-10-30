class AccountsController < ApplicationController
<<<<<<< HEAD

  before_action :set_account, only: [:show, :edit, :update, :destroy]	
  
  def index  
=======
<<<<<<< HEAD

  before_action :set_account, only: [:show, :edit, :update, :destroy]	
  
  def index  
=======
<<<<<<< HEAD
=======
  #FIXME_AB: authorize can be moved to application_controller
  before_action :authorize
  before_action :set_account, only: [:show, :edit, :update, :destroy]	

  def index  
    @accounts= Account.all
    render :json => @accounts.collect {|x| {:label=>x.name, :value=>x.id}}.compact
  end
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6

  before_action :set_account, only: [:show, :edit, :update, :destroy] 
  
  def index  
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
>>>>>>> f01e2da8c6384e5dff3e14723a433bf8bf33d6e2
    @accounts= Account.all.page(params[:page]).per(50)
    respond_to do |format|
      format.html { }
      format.json { render :json => @accounts.collect {|x| {:label=>x.name, :value=>x.id}}.compact}
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
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
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
      #FIXME_AB: what if account not found with that id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name)
    end 
 end

