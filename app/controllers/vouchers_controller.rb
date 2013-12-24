class VouchersController < ApplicationController
  before_action :set_voucher, only: [:show, :edit, :update, :destroy, :check_voucher_state, :check_user_type, :increment_state, :decrement_state]
  before_action :check_user_and_voucher_state ,only: [:edit]
  before_action :default_tab, only: [:index, :all, :report]
  before_action :set_comment_owner, only: [:create, :update]
  #helper_method :get_vouchers
  # GET /vouchers
  # GET /vouchers.json
  #FIXME_AB: Can we make more use of associations and scopes?
  def index
    if params[:tag]
      @vouchers = Voucher.tagged_with(params[:tag]).send(default_tab)
    elsif params[:user_id]
      @vouchers = User.find(params[:user_id]).vouchers.send(default_tab)
    elsif params[:account_id]
      @vouchers = Account.find(params[:account_id]).vouchers.send(default_tab)
    elsif default_tab == "drafted"
      @vouchers = current_user.vouchers.send(default_tab)
    else
      @vouchers = Voucher.send(default_tab)
    end
    @vouchers = @vouchers.including_accounts_and_transactions.page(params[:page])
  end


  # GET /vouchers/new
  def new
    #FIXME_AB: where are we using these local variables. Also comment.user_id can be set at the time of building the object. no?
    @voucher = Voucher.new
    @uploads = @voucher.attachments.build  
    @comments =@voucher.comments.build
    @transactions = @voucher.transactions.build
  end

  # GET /vouchers/1
  # GET /vouchers/1.json
  def show
  end

  
  # GET /vouchers/1/edit
  def edit
  end

  # POST /vouchers
  # POST /vouchers.json
  def create
   @voucher = current_user.vouchers.build(voucher_params)
    respond_to do |format|
      if @voucher.save
        flash[:notice] = "Voucher #" + @voucher.id.to_s + " was successfully created."
        format.html
        format.json { render action: 'show', status: :created, location: @voucher }
        format.js {render js: %(window.location.href='#{voucher_path @voucher}')}
      else
         format.html { render action: 'new' }
         format.js 
         format.json { render json: @voucher.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /vouchers/1
  # PATCH/PUT /vouchers/1.json
  def update
    respond_to do |format|
      if @voucher.update(voucher_params)
        flash[:notice] = "Voucher #" + @voucher.id.to_s + " was successfully updated"
        format.html
        format.json { head :no_content }
        format.js {render js: %(window.location.href = '#{voucher_path @voucher}')}
      else
        format.html { render action: 'edit' }
        format.json { render json: @voucher.errors, status: :unprocessable_entity }
        format.js { render 'vouchers/create.js.erb'}
      end
    end
  end

  def pending
    get_vouchers('pending')
    set_default_tab('pending')
    render action: 'index'
  end

  def accepted
    get_vouchers('accepted')
    set_default_tab('accepted')
    render action: 'index' 
  end

  def archived
    get_vouchers('archived')
    set_default_tab('archived')
    render action: 'index'
  end


  def approved 
    get_vouchers('approved')
    set_default_tab('approved')  
    render action: 'index' 
  end

  def drafted
    get_vouchers('drafted')
    set_default_tab('drafted')
    render action: 'index'
  end

  #FIXME_AB: Home page is served by this action. I think you should have a dashboard resource(singular) for this.
  def assigned
    @vouchers =  Voucher.not_accepted.assignee(current_user.id).including_accounts_and_transactions.order('updated_at desc') 
  end

  def rejected
    get_vouchers('rejected')
    set_default_tab('rejected')
    render action: 'index'
  end

  # DELETE /vouchers/1
  # DELETE /vouchers/1.json
  def destroy
    notice = "Voucher #" + @voucher.id.to_s + " was deleted successfully"
    @voucher.destroy 
    respond_to do |format|
      format.html { redirect_to :back ,notice: notice}
      format.json { head :no_content }
    end
  end
 
  def increment_state
    @voucher.increment_state(current_user)
    notice = "Voucher #"  + @voucher.id.to_s + " has been assigned to " + @voucher.assignee.first_name  if(!(@voucher.accepted? || @voucher.archived?))
    redirect_to :back, notice: notice
  end
 
  def decrement_state
    @voucher.decrement_state(current_user)
    notice = "Voucher #"  + @voucher.id.to_s + " rejected successfully and assigned back to " + @voucher.creator.name
    redirect_to :back, notice: notice
  end

 
  #FIXME_AB: I think we should have separate controller for reporting.
  

  protected

    def check_user_and_voucher_state
      #FIXME_AB: This logic can be written little better
      if !(@voucher.creator?(current_user) && @voucher.can_be_edited?)
        redirect_to_back_or_default_url
      end
      # if (current_user.admin? || @voucher.creator?(current_user))
      #   if !(@voucher.drafted? || @voucher.rejected?)
      #     redirect_to_back_or_default_url
      #   end
      # else
      #   redirect_to_back_or_default_url
      # end
    end

    def get_vouchers(state)
      if params[:account_id]
        if params[:account_type]
          @vouchers = Account.find(params[:account_id]).send("vouchers_" + params[:account_type] + "ed").send(state)
        else
          @vouchers = Account.find(params[:account_id]).vouchers.send(state)
        end
      elsif params[:user_id]
        @vouchers = User.find(params[:user_id]).vouchers.send(state)
      elsif params[:tag]
        @vouchers = Voucher.tagged_with(params[:tag]).send(state)
      elsif(params[:to] && params[:from])
        @vouchers = Voucher.where('date between (?) and (?)', params[:from], params[:to]).send(state)
        filter_by_name_and_type(@vouchers, params[:report_account], params[:account_type])
      elsif state.inquiry.drafted?
        @vouchers = current_user.vouchers.drafted
      else
        @vouchers = Voucher.send(state)
      end
      @vouchers = @vouchers.including_accounts_and_transactions.page(params[:page])
    end



    def filter_by_name_and_type(vouchers ,name, type)
      if name.present?
        @vouchers = vouchers.includes(:transactions).where(:transactions => {:account_id => name})
        @vouchers = @vouchers.where(:transactions => {:account_type => type}) if type.present?
      end
     @vouchers
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
      params.require(:voucher).permit(:date, :tag_list, :from_date, :to_date, :assignee_id, :account_credited, transactions_attributes: [:account_id, :voucher_id, :id, :_destroy, :account_type, :amount, :payment_type, :payment_reference], comments_attributes: [:description, :id, :_destroy, :user_id], attachments_attributes:[ :tagname, :id, :_destroy, :bill_attachment] ).merge({ assignee_id: current_user.id})
    end

    #FIXME_AB: This method is not setting session so the name of this method can be something else like set_default_tab.
    def set_default_tab(type)
      session[:previous_tab] =  type
    end

    def default_tab
      session[:previous_tab] || 'drafted'
    end
  
   def set_comment_owner
    if params[:voucher][:comments_attributes].present?
      params[:voucher][:comments_attributes].each do |comment_id, content|
        content[:user_id] = current_user.id
      end
    end
  end

  # def eager_load_associations
  #   @vouchers = @vouchers.includes(:debit_from, :credit_to, :debited_transactions, :credited_transactions)
  # end
  #FIXME_AB: Better to have this line at the top. Just a good practice
  
end