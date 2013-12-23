class VouchersController < ApplicationController
  before_action :set_voucher, only: [:show, :edit, :update, :destroy, :check_voucher_state, :check_user_type, :increment_state, :decrement_state]
  before_action :check_user_and_voucher_state ,only: [:edit]
  before_action :convert_date, only: [:generate_report]
  before_action :set_session, only: [:index, :all, :report]

  # GET /vouchers
  # GET /vouchers.json
  #FIXME_AB: Can we make more use of associations and scopes?
  def index
    if params[:tag]
      @vouchers = Voucher.tagged_with(params[:tag]).send(session[:previous_tab]).page(params[:page])
    elsif params[:user_id]
      @vouchers = Voucher.send(session[:previous_tab]).where(creator_id: params[:user_id]).page(params[:page])
    elsif params[:account_id]
      @vouchers = Voucher.includes(:transactions).where(:transactions => {:account_id => params[:account_id]}).send(session[:previous_tab]).page(params[:page])
    elsif session[:previous_tab] == "drafted"
      @vouchers = Voucher.send(session[:previous_tab]).where(creator_id: current_user.id).page(params[:page])
    else
      @vouchers = Voucher.send(session[:previous_tab]).page(params[:page])
    end
    respond_to do |format|
      format.html  
    end
  end


  # GET /vouchers/new
  def new
    #FIXME_AB: where are we using these local variables. Also comment.user_id can be set at the time of building the object. no?
    @voucher = Voucher.new
    uploads = @voucher.attachments.build  
    comments =@voucher.comments.build
    transactions = @voucher.transactions.build
    @voucher.comments.each do |comment| 
      comment.user_id = current_user.id
    end
  end

  # GET /vouchers/1
  # GET /vouchers/1.json
  def show
  end

  
  # GET /vouchers/1/edit
  def edit
    #FIXME_AB: Do we actually need following lines?
   respond_to do |format|
      format.html     
    end
  end

  # POST /vouchers
  # POST /vouchers.json
  def create
   @voucher = current_user.vouchers.build(voucher_params)
   #FIXME_AB: can this be done using a callback
    @voucher.comments.each do |comment| 
      comment.user_id = current_user.id
    end
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
    if params[:voucher][:comments_attributes].present?
      params[:voucher][:comments_attributes].each do |comment_id ,content|
        #FIXME_AB: Why relying on the user_id coming from the params
        content[:user_id] =current_user.id if content[:user_id].blank?
      end
    end 
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
    session[:previous_tab] = 'pending'
    respond_to do |format|
      format.html { render action: 'index'}
    end  
  end

  def accepted
    get_vouchers('accepted')
    session[:previous_tab] = 'accepted'
    respond_to do |format|
      format.html { render action: 'index'}
    end  
  end

  def archived
    get_vouchers('archived')
    session[:previous_tab] = 'archived'
    respond_to do |format|
      format.html { render action: 'index'}
    end  
  end

  def all
    #FIXME_AB: default_tab == 'drafted'
    if session[:previous_tab] == "drafted"
      #FIXME_AB: current_user.vouchers.drafted
      @vouchers = Voucher.send(session[:previous_tab]).where(creator_id: current_user.id).page(params[:page])
    else
      @vouchers = Voucher.send(session[:previous_tab]).page(params[:page]) 
    end
    #FIXME_AB: Since you are not using any other format, you can avoid following lines
    respond_to do |format|
      format.html { render action: 'index'}   
    end
  end


  def approved 
    get_vouchers('approved')
    #FIXME_AB: set_default_tab('approved')
    session[:previous_tab] = 'approved'
    respond_to do |format|
      format.html { render action: 'index' }
    end  
  end

  def drafted
    get_vouchers('drafted')
    session[:previous_tab] = 'drafted'
    respond_to do |format|
      format.html { render action: 'index'}
     end  
  end

  #FIXME_AB: Home page is served by this action. I think you should have a dashboard resource(singular) for this.
  def assigned
    #FIXME_AB: Why can't we create scopes. Voucher.not_accepted.assignee(current_user)
    @vouchers =  Voucher.where("workflow_state not in ('accepted')  and assignee_id = #{current_user.id}").order('updated_at desc')
    respond_to do |format|
      format.html
    end
  end

  def rejected
    get_vouchers('rejected')
    session[:previous_tab] = 'rejected'
    respond_to do |format|
      format.html { render action: 'index' }
    end
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
    #FIXME_AB: Do we have a check on model level that states can not be jumped.
    #FIXME_AB: Also much of this can be moved to model itself. Please identify and move them
    case "#{@voucher.current_state}"
      when "rejected" then @voucher.send_for_approval!
      when "drafted" then @voucher.send_for_approval!
      when "pending" then @voucher.approve!(current_user)
      when "approved" then @voucher.accept!(current_user)
      when "accepted" then @voucher.archive!
    end 
    if @voucher.current_state == :archived
      @voucher.assignee_id = nil
    elsif @voucher.current_state == :accepted
      @voucher.assignee_id = current_user.id
    else
      @voucher.assignee_id = params[:voucher][:assignee_id]
    end   
    
    @voucher.save!
    @voucher.create_activity key: 'voucher.change_assigned_to', owner: @voucher.assignee, recipient: current_user
    notice = "Voucher #"  + @voucher.id.to_s + " has been assigned to " + @voucher.assignee.first_name  if(!(@voucher.accepted? || @voucher.archived?))
    redirect_to :back, notice: notice
  end
 
  def decrement_state
    #FIXME_AB: much of this can be moved to model itself. Please identify and move them
    case "#{@voucher.current_state}"
      when "pending" then @voucher.reject!(current_user)
      when "approved" then @voucher.reject!(current_user)
    end
    @voucher.assignee_id = @voucher.creator_id
    @voucher.save!
    notice = "Voucher #"  + @voucher.id.to_s + " rejected successfully and assigned back to " + @voucher.creator.name
    @voucher.create_activity key: 'voucher.rejected', owner: @voucher.creator
    redirect_to :back, notice: notice
  end

  def search
    @vouchers = Voucher.search Riddle.escape(params[:query]), :page => params[:page], :per_page => 5
  end
  
  #FIXME_AB: I think we should have separate controller for reporting.
  def report 
    params[:from]  = Date.today.beginning_of_month()
    params[:to]  = Date.today.end_of_month()
  end

  #FIXME_AB: I think we should have separate controller for reporting.
  def generate_report
    #FIXME_AB: What about params[:to]
    if params[:from].nil?
      redirect_to report_path
    elsif params[:from].present? && params[:from] > params[:to]
      #FIXME_AB: What are valid values, can we be more precise 
      redirect_to report_path , notice: "Please enter valid values"
    end
    @voucher_startDate = params[:from]
    @voucher_endDate = params[:to]
    @voucher_accountName = params[:report_account]
    @voucher_accountType = params[:account_type]
  end

  protected

    def check_user_and_voucher_state
      #FIXME_AB: This logic can be written little better
      if (current_user.admin? || @voucher.creator?(current_user))
        if !(@voucher.drafted? || @voucher.rejected?)
          redirect_to_back_or_default_url
        end
      else
        redirect_to_back_or_default_url
      end
    end

    def get_vouchers(state)
      if params[:account_id]
        if params[:account_type]
          @vouchers = Voucher.includes(:transactions).where(:transactions => {:account_id => params[:account_id], :account_type => params[:account_type]}).where(workflow_state: state).page(params[:page])
        else
          @vouchers = Voucher.includes(:transactions).where(:transactions => {:account_id => params[:account_id]}).where(workflow_state: state).page(params[:page])     
        end
      elsif params[:user_id]
        @vouchers = Voucher.where(workflow_state: state).where(creator_id: params[:user_id]).page(params[:page]) 
      elsif params[:tag]
        @vouchers = Voucher.tagged_with(params[:tag]).where(workflow_state: state).page(params[:page]) 
      elsif(params[:to] && params[:from])
        @vouchers = Voucher.where(workflow_state: state).where('date between (?) and (?)', params[:from], params[:to]).page(params[:page]) 
        filter_by_name_and_type(@vouchers, params[:report_account], params[:account_type])
      elsif state == 'drafted'
        @vouchers = Voucher.where(workflow_state: 'drafted').where(creator_id: current_user.id).page(params[:page]) 
      else
        @vouchers = Voucher.where(workflow_state: state).order('date desc').page(params[:page]) 
      end
    end

    def filter_by_name_and_type(vouchers ,name, type)
      if !name.blank?
        @vouchers = vouchers.includes(:transactions).where(:transactions => {:account_id => name})
        @vouchers = @vouchers.includes(:transactions).where(:transactions => {:account_type => type}) if !type.blank?
      end
     @vouchers
    end
 
  # Use callbacks to share common setup or constraints between actions.
   
    def set_voucher
      @voucher = Voucher.find_by(id: params[:id])
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
    def set_session
      if session[:previous_tab].nil?
        session[:previous_tab] = 'drafted'
      end
    end



    def convert_date
      if params[:from]
        params[:from] = params[:from].to_date
        #FIXME_AB: what if param[:to] is nil?
        params[:to] = params[:to].to_date
      end
    end
 
  #FIXME_AB: Better to have this line at the top. Just a good practice
  helper_method :get_vouchers
end