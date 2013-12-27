class VouchersController < ApplicationController
  
  before_action :set_voucher, only: [:show, :edit, :update, :destroy, :check_user_and_voucher_state, :increment_state, :decrement_state]
  before_action :check_user_and_voucher_state, only: [:edit]
  before_action :default_tab, only: [:index]
  before_action :set_comment_owner, only: [:create, :update]
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
        format.js {render js: %(window.location.href='#{voucher_path @voucher}')}
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
        format.js { render "shared/_error_messages", locals: {:target => @voucher}}
      end
    end

  end

  def pending
    get_vouchers('pending')
    render action: 'index'
  end

  def accepted
    get_vouchers('accepted')
    render action: 'index' 
  end

  def archived
    get_vouchers('archived')
    render action: 'index'
  end


  def approved 
    get_vouchers('approved')
    render action: 'index' 
  end

  def drafted
    get_vouchers('drafted')
    render action: 'index'
  end

  #FIXME_AB: Home page is served by this action. I think you should have a dashboard resource(singular) for this.
 

  def rejected
    get_vouchers('rejected')
    render action: 'index'
  end

  def destroy
    @voucher.destroy 
    redirect_to :back, notice: "Voucher #" + @voucher.id.to_s + " was deleted successfully" 
  end
 
  def increment_state
    @voucher.assignee_id = params[:voucher][:assignee_id]
    @voucher.increment_state(current_user)
    redirect_to :back, notice: "Voucher #"  + @voucher.id.to_s + " has been assigned to " + @voucher.assignee.first_name  if(!(@voucher.accepted? || @voucher.archived?))
  end
 
  def decrement_state
    @voucher.decrement_state(current_user) 
    redirect_to :back, notice: "Voucher #"  + @voucher.id.to_s + " rejected successfully and assigned back to " + @voucher.creator.name
  end

 
  def get_vouchers(state)
  
    @vouchers = Voucher.all

    @vouchers = @vouchers.created_by(params[:user_id]) if params[:user_id] 

    @vouchers = @vouchers.tagged_with(params[:tag]) if params[:tag]

    @vouchers = @vouchers.by_account(params[:account_id]) if params[:account_id]       

    @vouchers = @vouchers.by_transaction_type(params[:transaction_type]) if params[:transaction_type]
 

    if( params[:to] && params[:from] )

      @vouchers = @vouchers.between_dates(params[:from], params[:to])
      
      filter_by_name_and_type(@vouchers, params[:account], params[:transactions_type]) 

    end
    
    @vouchers = @vouchers.created_by(params[:user_id].presence || current_user.id) if state == "drafted"

    @vouchers = @vouchers.send(state).including_accounts_and_transactions.page(params[:page])

  end

  def filter_by_name_and_type(vouchers, name, type)
  
    if name.present?
      @vouchers = vouchers.by_account(name)
      @vouchers = @vouchers.by_transaction_type(type) if type.present?
    end
    @vouchers
  
  end

  protected

    def check_user_and_voucher_state
      #FIXME_AB: This logic can be written little better
      if !(@voucher.creator?(current_user) && @voucher.can_be_edited?)
        redirect_to_back_or_default_url
      end
    
    end
  # Use callbacks to share common setup or constraints between actions.
   
    def set_voucher
      @voucher = Voucher.including_accounts_and_transactions.find_by(id: params[:id])
      if @voucher.nil?
        redirect_to vouchers_path, notice: "Voucher you are looking for does not exist."
      end  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voucher_params
      #FIXME_AB: Can we break this into a multiline array. This is too long to understand
      params.require(:voucher).permit(:date, :tag_list, :from_date, :to_date, :assignee_id, :account_credited, transactions_attributes: [:account_id, :voucher_id, :id, :_destroy, :transaction_type, :amount, :payment_type, :payment_reference], comments_attributes: [:description, :id, :_destroy, :user_id], attachments_attributes:[ :tagname, :id, :_destroy, :bill_attachment] ).merge({ assignee_id: current_user.id})
    end

    #FIXME_AB: This method is not setting session so the name of this method can be something else like set_default_tab.

    def set_default_tab
      session[:previous_tab] =  params[:action]
    end


    def default_tab
      session[:previous_tab] || 'drafted'
    end
  
    def set_comment_owner
      #if params[:voucher][:comments_attributes].present?
        params[:voucher][:comments_attributes].each do |comment_id, content|
          content[:user_id] = current_user.id
        end
      #end
    end

end