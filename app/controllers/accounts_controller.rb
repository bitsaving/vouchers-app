class AccountsController < ApplicationController

  before_action :set_account, only: [:show, :edit, :update] 

  def index
    @accounts = Account.page(params[:page])
  end


  def new
    @account = Account.new
  end
 
  # POST /accounts
  # POST /accounts.json
  
  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to new_account_url, notice: 'Account ' + @account.name + ' was successfully created.'
    
    else
      render action: 'new'
    end
  end
  
  def edit
  end
  
  def show 
    #FIXME_AB: Do we actually need this respond_to block
    #fixed
  end
  
  def update
    if @account.update(account_params)
      redirect_to account_vouchers_path(@account), notice: 'Account ' + @account.name + ' was successfully updated.' }
    else
      render action: 'edit' 
    end
  end
  

  def autocomplete_suggestions
    render :json => Account.get_autocomplete_suggestions(params[:term]).collect { |x| { :label => x.name , :value => x.id } }.compact 
  end
 

  protected
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find_by(id: params[:id])
      if(@account.nil?)  
        flash[:notice] = "Account not found"
        redirect_to_back_or_default_url
      end
    end

    # Never trust parameters from the scary INTERNET, only allow the white list through.
    def account_params
      params.require(:account).permit(:name)
    end 

 end

