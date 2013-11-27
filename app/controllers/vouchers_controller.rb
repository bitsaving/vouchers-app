class VouchersController < ApplicationController
  before_action :set_voucher, only: [:show, :edit, :update, :destroy,:check_voucher_state,:check_user_type ,:increment_state ,:decrement_state]
  before_action :check_user_and_voucher_state ,only: [:edit]
  # GET /vouchers
  # GET /vouchers.json
  def index

    if params[:tag]
      @vouchers = Voucher.tagged_with(params[:tag]).where(workflow_state: 'new').page(params[:page])
    elsif params[:user_id]
      @vouchers = Voucher.where(creator_id: params[:user_id]).where(workflow_state: 'new').page(params[:page])
    else
      @vouchers = Voucher.where(workflow_state: 'new').where(creator_id: current_user.id).page(params[:page])
    end
    respond_to do |format|
      format.html  
    end
  end


# GET /vouchers/new
  def new
    
    @voucher = Voucher.new
    uploads = @voucher.attachments.build
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
     
    end
  end

  def report  
  end

  def generate_report
    if params[:from].nil? or params[:from].to_date > params[:to].to_date
      redirect_to report_path , notice: "Please enter valid values"
    end
     @voucher_startDate = params[:from].to_date
     @voucher_endDate = params[:to].to_date
     @voucher_accountName = params[:report_account]
     @voucher_accountType = params[:account_type]
    respond_to do |format|
      format.html  {}
    end
  end

#  def get_vouchers_by_type
#   if params[:account_type] != 'Both'
#    @account_type = params[:account_type]
#    end
#    @account = params[:account]
#    get_vouchers(params[:state])
#    respond_to do |format|
#     format.html { render :template => 'vouchers/index' ,locals: {params: {account_id: @account ,account_type: @account_type} ,:@vouchers => @vouchers}}
#   end
# end



  # GET /vouchers/1/edit
  def edit
  end

  # POST /vouchers
  # POST /vouchers.json
  def create
   @voucher = current_user.vouchers.build(voucher_params)
    @voucher.comments.each do |comment| 
      comment.user_id = current_user.id
    end
    respond_to do |format|
      if @voucher.save
        flash[:notice] = "Voucher #" + @voucher.id.to_s + " was successfully created."
        format.html {}
        format.json { render action: 'show', status: :created, location: @voucher }
        format.js {render js: %(window.location.href='#{voucher_path @voucher}')}
      else
         format.html { render action: 'new' }
         format.js {}
         format.json { render json: @voucher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vouchers/1
  # PATCH/PUT /vouchers/1.json
  def update
    if params[:voucher][:comments_attributes].present?
    params[:voucher][:comments_attributes].each do |comment_id ,content|
      content[:user_id] =current_user.id if content[:user_id].blank?
    end
    end 
    respond_to do |format|
      if @voucher.update(voucher_params)
        flash[:notice] = "Voucher #" + @voucher.id.to_s + " was successfully updated"
        format.html {}
        format.json { head :no_content }
         format.js {render js: %(window.location.href='#{voucher_path @voucher}')}
      else
        format.html { render action: 'edit' }
        format.json { render json: @voucher.errors, status: :unprocessable_entity }
        format.js { render 'vouchers/create.js.erb'}
      end
    end

  end


  def pending

    get_vouchers('pending')
    respond_to do |format|
      format.html { render action: 'index'}
      #format.js { render partial: 'vouchers' }
      #format.js
    end  
  end

  def accepted
    get_vouchers('accepted')
    respond_to do |format|
      format.html { render action: 'index'}
    end  
  end

  def all
    @vouchers = Voucher.where(workflow_state: 'new').where(creator_id: current_user.id).page(params[:page]) 
    respond_to do |format|
      format.html { render action: 'index'}
     
    end
  end

  def approved 
    get_vouchers('approved')
    respond_to do |format|
      format.html { render action: 'index' }
    end  
  end

  def drafted
    get_vouchers('new')
    respond_to do |format|
      format.html { render action: 'index'}
      #format.js {}
     end  
  end

  def assigned
    @vouchers =  Voucher.where("workflow_state not in ('accepted')  and assignee_id = #{current_user.id}").order('updated_at desc').page(params[:page]) 
    respond_to do |format|
      format.html {}
    end
  end

  # def get_by_state
  #   if params[:state]
  #     if params[:state] != 'new'
  #       @vouchers = Voucher.where('workflow_state in (?)', params[:state]).page(params[:page]) 
  #     else
  #       @vouchers = Voucher.where('workflow_state in (?)', params[:state]).where('creator_id in (?)' ,current_user.id).page(params[:page]) 
  #     end
  #   elsif(params[:to] && params[:from])
  #      @vouchers = Voucher.where(workflow_state: state).where('date between (?) and (?)',params[:from],params[:to]).order('updated_at desc').page(params[:page]) 
  #   else
  #      @vouchers = Voucher.where('workflow_state in (?)', 'PENDING').page(params[:page])  
  #     end
  #    Rails.logger.debug "$$$$ #{@vouchers}"
  #    respond_to do |format|
  #     format.html { render action: 'index' }
  #     format.js { render partial: 'vouchers' }
  #   end  
  # end

  def rejected
    get_vouchers('rejected')
    respond_to do |format|
      format.html { render action: 'index' }
      #format.js { }
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
      @voucher.create_activity key: 'voucher.change_assigned_to', owner: @voucher.assignee,recipient: current_user
      notice = "Voucher "  + @voucher.id.to_s + " has been assigned to " + @voucher.assignee.first_name  if(@voucher.workflow_state != "accepted")
      # @voucher.create_activity key: 'voucher.change_state', owner: @voucher.creator
      redirect_to :back , notice: notice
  end
 
  def decrement_state
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

  # def check_voucher_state
  #   if !(@voucher.workflow_state == 'new' || @voucher.workflow_state == 'rejected')
  #     redirect_if_no_referer 
  #   end
  # end

  def check_user_and_voucher_state
    if current_user.admin? || current_user.id == @voucher.creator_id
      if !(@voucher.workflow_state == 'new' || @voucher.workflow_state == 'rejected')
        redirect_if_no_referer
      end
    else
      redirect_if_no_referer
    end
  end

  def get_vouchers(state)
    if params[:account_id]
      if params[:account_type]
        @vouchers = Voucher.where(workflow_state: state).where("account_#{params[:account_type]}ed in (?)" ,params[:account_id]).page(params[:page]) 
      else
      @vouchers = Voucher.where(workflow_state: state).where('account_debited in (?) OR account_credited in (?)', params[:account_id],params[:account_id]).page(params[:page]) 
      end
    elsif params[:user_id]
      @vouchers = Voucher.where(workflow_state: state).where(creator_id: params[:user_id]).page(params[:page]) 
    elsif params[:tag]
      @vouchers = Voucher.tagged_with(params[:tag]).where(workflow_state: state).page(params[:page]) 
    elsif(params[:to] && params[:from])
       @vouchers = Voucher.where(workflow_state: state).where('date between (?) and (?)',params[:from],params[:to]).page(params[:page]) 
        filter_by_name_and_type(@vouchers, params[:report_account] ,params[:account_type])
    elsif state == 'new'
      @vouchers = Voucher.where(workflow_state: 'new').where(creator_id: current_user.id).page(params[:page]) 
    else
      @vouchers = Voucher.where(workflow_state: state).order('date desc').page(params[:page]) 
    end
  end

  def filter_by_name_and_type(vouchers ,name, type)
    if !name.nil?
      @vouchers = vouchers.where('account_debited in (?) OR account_credited in (?)',name,name)
      @vouchers = @vouchers.where('account_'+ type +'ed in (?)', name) if !type.blank?
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_voucher
      @voucher = Voucher.find(params[:id])
      rescue ActiveRecord::RecordNotFound 
        redirect_to vouchers_path ,notice: "Voucher you are looking for does not exist."
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voucher_params
      params.require(:voucher).permit(:date,:tag_list,:from_date,:to_date,:payment_reference,:assignee_id,:account_debited,:account_credited,:amount,:payment_type, comments_attributes:[:description,:id,:_destroy,:user_id],attachments_attributes:[:tagname,:id, :_destroy,:bill_attachment] ).merge({ assignee_id: current_user.id })
    end

end
