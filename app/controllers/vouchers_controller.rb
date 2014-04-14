
class VouchersController < ApplicationController

  before_action :set_voucher, only: [:show, :edit, :update, :destroy, :check_user_and_voucher_state, :increment_state, :decrement_state]
  before_action :check_user_and_voucher_state, only: [:edit]
  before_action :default_tab, only: [:index]
  # before_action :set_comment_owner, only: [:create, :update]
  before_action :set_default_tab, only: [:pending, :drafted, :accepted, :approved, :rejected, :archived]

  helper_method :get_vouchers
 
  def index
    get_vouchers(default_tab)
  end


  def new

    @voucher = Voucher.new
    @uploads = @voucher.attachments.build  
    @comments = @voucher.comments.build
    @transactions = @voucher.transactions.build

  end

  def show
  end

  
  def edit
  end

 
  def create

    @voucher = current_user.vouchers.build(voucher_params)
    respond_to do |format|
      if @voucher.save
        flash[:notice] = "Voucher #" + @voucher.id.to_s + " was successfully created."
        format.js { render js: %(window.location.href='#{voucher_path @voucher}')}
      else
        format.js {render "shared/_error_messages", locals: { :target => @voucher } }
      end
    end
  end



  def update

    respond_to do |format|
      if @voucher.update(voucher_params)
        flash[:notice] = "Voucher #" + @voucher.id.to_s + " was successfully updated"
        format.js {render js: %(window.location.href = '#{voucher_path @voucher}') }
      else
        format.js { render :template => "shared/_error_messages", locals: { :target => @voucher } }
      end
    end

  end

  def pending
  end

  def accepted
  end

  def archived
  end

  def approved 
  end

  def drafted
  end

  def rejected
  end

  def destroy
    @voucher.destroy 
    redirect_to :back, notice: "Voucher #" + @voucher.id.to_s + " was deleted successfully" 
  end
 
  def increment_state
    @voucher.assignee_id = params[:voucher][:assignee_id] 
    @voucher.change_state(current_user, "increment")
    flash[:notice] =  "Voucher #"  + @voucher.id.to_s + " has been assigned to " + @voucher.assignee.first_name  if(!(@voucher.accepted? || @voucher.archived?))
    redirect_to voucher_path(@voucher)
  end
 
  def decrement_state
    @voucher.change_state(current_user, "decrement") 
    redirect_to voucher_path(@voucher), notice: "Voucher #"  + @voucher.id.to_s + " rejected successfully and assigned back to " + @voucher.creator.name
  end

 
  def get_vouchers(state)
    @vouchers = Voucher.all

    @vouchers = @vouchers.created_by(params[:user_id]) if params[:user_id] 

    @vouchers = @vouchers.tagged_with(params[:tag]) if params[:tag].present?

    @vouchers = @vouchers.by_account(params[:account_id]) if params[:account_id]       

    @vouchers = @vouchers.by_transaction_type(params[:transaction_type]) if params[:transaction_type]
 
    @vouchers = @vouchers.between_dates(params[:from], params[:to]) if params[:from]
     
    filter_by_name_and_type(@vouchers, params[:account], params[:transactions_type])
    
    @vouchers = @vouchers.created_by(params[:user_id].presence || current_user.id) if state == "drafted"

    @vouchers = @vouchers.send(state).including_accounts_and_transactions.page(params[:page])

  end


  def filter_by_name_and_type(vouchers, name, type)

    @vouchers = vouchers.by_account(name) if name.present?
    @vouchers = @vouchers.by_transaction_type(type) if type.present?

  end


  def print
    @vouchers = params[:vouchers]
  end

  protected

    def check_user_and_voucher_state
      redirect_to_back_or_default_url if !@voucher.can_be_edited?(current_user) 
    end
   
    def set_voucher
      @voucher = Voucher.including_accounts_and_transactions.find_by(id: params[:id])    
      redirect_to vouchers_path, notice: "Voucher you are looking for does not exist." if @voucher.nil?
    end

    def voucher_params
      params.require(:voucher).permit(:date, :description, :tag_list, :from_date, :to_date, :assignee_id, :account_credited, transactions_attributes: [:account_id, :voucher_id, :id, :_destroy, :transaction_type, :amount, :payment_type, :payment_reference], comments_attributes: [:description, :id, :_destroy, :user_id], attachments_attributes:[ :tagname, :id, :_destroy, :bill_attachment] ).merge({ assignee_id: current_user.id})
    end

    def set_default_tab
      session[:previous_tab] =  params[:action]
      get_vouchers(params[:action])
      render action: 'index'
    end


    
  
    # def set_comment_owner
    #   # if params[:voucher][:comments_attributes].present?
    #   #   params[:voucher][:comments_attributes].each_value do |content|
    #   #     content[:user_id] = current_user.id
    #   #   end
    #   # end
    # end

end