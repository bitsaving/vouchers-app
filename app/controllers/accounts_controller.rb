#FIXME_AB: Remove format html and json blocks where we don't need them, as discussed.
class AccountsController < ApplicationController

  before_action :set_account, only: [:show, :edit, :update] 

  def index
    #FIXME_AB: we can break this action in two. One for index and one for autocomplete. 
    if params[:term]
      #FIXME_AB: Account.find_suggestions(term)
      account_name = "%".concat(params[:term].concat("%"))
      @accounts = Account.where('name LIKE (?)', account_name)
    else
      @accounts = Account.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json { render :json => @accounts.collect { |x| { :label => x.name , :value => x.id } }.compact } 
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
        format.html { redirect_to new_account_url, notice: 'Account ' + @account.name + ' was successfully created.' }
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
        format.html { redirect_to account_vouchers_path(@account), notice: 'Account ' + @account.name + ' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
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

