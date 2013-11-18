class VouchersController < ApplicationController
  before_action :set_voucher, only: [:show, :edit, :update, :destroy,:check_voucher_state,:check_user_type]
  before_action :check_voucher_state ,only: [:edit]
  before_action :check_user_type ,only: [:edit]
  # GET /vouchers
  # GET /vouchers.json
  def index
    if params[:tag]
      @vouchers = Voucher.tagged_with(params[:tag]).where(creator_id: current_user.id).page(params[:page]).per(50)
    else
      @vouchers = Voucher.where(creator_id: current_user.id).page(params[:page]).per(50)
    end
     respond_to do |format|
      format.html  
      format.js {}
    end
  end
# GET /vouchers/new
  def new
    
    @voucher = Voucher.new
    uploads = @voucher.uploads.build
    comments =@voucher.comments.build
    @voucher.comments.each do |comment| 
      comment.user_id = current_user.id
    end
  end


  # GET /vouchers/1
  # GET /vouchers/1.json
  def show
    respond_to do |format|
      format.html  
      format.js {}
    end
  end

  def report  
  end

  def generate_report
    if params[:from].nil? or params[:from].to_date > params[:to].to_date
      redirect_to report_path , notice: "Please enter valid values"
    end
    respond_to do |format|
      format.html  {}
      format.js {}
    end
  end

 

  # GET /vouchers/1/edit
  def edit
    #FIXME_AB: Redirect to back instead of home page
    #fixed 
  end

  # POST /vouchers
  # POST /vouchers.json
  def create

   @voucher = current_user.vouchers.build(voucher_params)
    @voucher.comments.each do |comment| 
      comment.user_id = current_user.id
    end
   # @voucher.comments[0].user_id = current_user.id if !@voucher.comments[0].nil?
    respond_to do |format|
      if @voucher.save
        format.html { redirect_to @voucher, notice: 'Voucher was successfully created.' }
        format.json { render action: 'show', status: :created, location: @voucher }
      else
         format.html { render action: 'new' }
         format.json { render json: @voucher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vouchers/1
  # PATCH/PUT /vouchers/1.json
  def update
    params[:voucher][:comments_attributes].each do |comment_id ,content|
      content[:user_id] =current_user.id if content[:user_id].blank?
    end 
    respond_to do |format|
      if @voucher.update(voucher_params)
        format.html { redirect_to @voucher, notice: 'Voucher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @voucher.errors, status: :unprocessable_entity }
      end
    end

  end

  def pending
    get_vouchers('pending')
    respond_to do |format|
      format.html { render action: 'index' }
      format.js {}
    end  
  end

  def all_vouchers 
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def approved 
    get_vouchers('approved')
    respond_to do |format|
      format.html { render action: 'index' }
      format.js {}
    end  
  end

  def drafted
    # if params[:user_id] == current_user.id

    #   @vouchers =  @vouchers = Voucher.where(workflow_state: state).where(creator_id: params[:user_id]).order('updated_at desc').page(params[:page]).per(10)
    get_vouchers('new')
    respond_to do |format|
      format.html { render action: 'index' }
      format.js {}
    end  
  end

  def waiting_for_approval
    @vouchers =  Voucher.where("workflow_state not in ('accepted','rejected')  and assignee_id = #{current_user.id}").order('updated_at desc').page(params[:page]).per(50)
    respond_to do |format|
      format.html { render action: 'index' }
    end
  end

  def accepted
    get_vouchers('accepted')
     respond_to do |format|
      format.html { render action: 'index' }
      format.js {}
    end  
  end
  def rejected
    get_vouchers('rejected')
    respond_to do |format|
      format.html { render action: 'index' }
      format.js {}
    end
  end
  # DELETE /vouchers/1
  # DELETE /vouchers/1.json
  def destroy
    @voucher.destroy
    respond_to do |format|
      format.html { redirect_to vouchers_url }
      format.json { head :no_content }
    end
  end
 
  def increment_state
    @voucher = Voucher.find(params[:id])
    case "#{@voucher.current_state}"
      when "rejected" then @voucher.send_for_approval!
      when "new" then @voucher.send_for_approval!
      when "pending" then @voucher.approve!(current_user.id)
      when "approved" then @voucher.accept!(current_user.id)
    end    
    @voucher.record_state_change(current_user.id) if !(@voucher.current_state == :pending)
      if @voucher.current_state == :accepted
        @voucher.assignee_id = nil
      else    
        @voucher.assignee_id = params[:voucher][:assignee_id]
      end
      @voucher.save!
      @voucher.create_activity key: 'voucher.change_assigned_to', owner: @voucher.assigned_to,recipient: current_user
      notice = "Voucher "  + @voucher.id.to_s + " has been assigned to " + @voucher.assigned_to.first_name  if(@voucher.workflow_state != "accepted")
      # @voucher.create_activity key: 'voucher.change_state', owner: @voucher.creator
      redirect_to :back , notice: notice
  end
 
  def decrement_state
    @voucher = Voucher.find(params[:id])
    case "#{@voucher.current_state}"
      when "pending" then @voucher.reject!(current_user.id)
      when "approved" then @voucher.reject!(current_user.id)
    end
    @voucher.record_state_change(current_user.id)
    @voucher.assignee_id = @voucher.creator_id
    @voucher.save!
    @voucher.create_activity key: 'voucher.rejected', owner: @voucher.creator
    redirect_to :back
  end

  
  protected

  def check_voucher_state
    if !(@voucher.workflow_state == 'new' || @voucher.workflow_state == 'rejected')
      redirect_to :back , notice: " You are not authorized to edit"
    end
  end

  def check_user_type
    current_user.admin? || current_user.id == @voucher.creator_id
  end

  def get_vouchers(state)
    if params[:account_id]
      @vouchers = Voucher.where(workflow_state: state).where(["account_#{params[:account_type]}ed IN (?)", params[:account_id]]).order('updated_at desc').page(params[:page]).per(10)
    elsif params[:user_id]
      @vouchers = Voucher.where(workflow_state: state).where(creator_id: params[:user_id]).order('updated_at desc').page(params[:page]).per(10)
    elsif(params[:to] && params[:from])
       @vouchers = Voucher.where(workflow_state: state).where('date between (?) and (?)',params[:from],params[:to]).order('updated_at desc').page(params[:page]).per(10)
     else
      @vouchers = Voucher.where(workflow_state: state).order('updated_at desc').page(params[:page]).per(10)
    end
    
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_voucher
      @voucher = Voucher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voucher_params
      params.require(:voucher).permit(:date,:tag_list,:from_date,:to_date,:payment_reference,:assignee_id,:account_debited,:account_credited,:amount,:payment_type, comments_attributes:[:description,:id,:_destroy,:user_id],uploads_attributes:[:tagname,:id, :_destroy,:avatar] )
    end
end
