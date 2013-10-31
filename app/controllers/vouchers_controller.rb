class VouchersController < ApplicationController


  before_action :set_voucher, only: [:show, :edit, :update, :destroy,:rename_file]
 
  # GET /vouchers
  # GET /vouchers.json
  def index
    @vouchers = Voucher.where(creator_id: current_user.id).page(params[:page]).per(50)
     respond_to do |format|
      format.html  
      format.js {}
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




  # GET /vouchers/new
  def new
    
    @voucher = Voucher.new
    uploads = @voucher.uploads.build
    comments =@voucher.comments.build
  end

  # GET /vouchers/1/edit
  def edit 
    if(!(current_user.user_type == "admin" || params[:id] == current_user.id))
      redirect_to root_path, notice: "No editing privileges for you"
    end 
  end

  # POST /vouchers
  # POST /vouchers.json
  def create
   @voucher = current_user.vouchers.build(voucher_params)
   @voucher.comments[0].user_id = current_user.id if !@voucher.comments[0].nil?
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

  def pending_vouchers
    if params[:account_id]
      @vouchers = Voucher.where(workflow_state: 'pending').where(["account_debited IN (?) OR account_credited IN (?)", params[:account_id],params[:account_id]]).order('updated_at desc').page(params[:page]).per(10)
    elsif params[:user_id]
      @vouchers = Voucher.where(workflow_state: 'pending').where(creator_id: params[:user_id]).order('updated_at desc').page(params[:page]).per(10)
    else
      @vouchers = Voucher.where(workflow_state: 'pending').page(params[:page]).order('updated_at desc').per(10)
    end
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

  def accepted_vouchers
    if params[:account_id]
      @vouchers = Voucher.where(workflow_state: 'accepted').where(["account_debited IN (?) OR account_credited IN (?)", params[:account_id],params[:account_id]]).order('updated_at desc').page(params[:page]).per(10)
    elsif params[:user_id]
      @vouchers = Voucher.where(workflow_state: 'accepted').where(creator_id: params[:user_id]).order('updated_at desc').page(params[:page]).per(10)
    else
      @vouchers = Voucher.where(workflow_state: 'accepted').order('updated_at desc').page(params[:page]).per(10)
    end
    respond_to do |format|
      format.html { render action: 'index' }
      format.js {}
    end  
  end
  def rejected_vouchers
    if params[:account_id]
      @vouchers = Voucher.where(workflow_state: 'rejected').where(["account_credited IN (?) OR account_debited IN (?)", params[:account_id],params[:account_id]]).order('updated_at desc').page(params[:page]).per(50)
    elsif params[:user_id]
      @vouchers = Voucher.where(workflow_state: 'rejected').where(creator_id: params[:user_id]).order('updated_at desc').page(params[:page]).per(10)
    else
      @vouchers = @vouchers = Voucher.where(workflow_state: 'rejected').page(params[:page]).order('updated_at desc').per(10)
    end
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
      when "pending" then @voucher.approve!
      when "approved" then @voucher.accept!
    end    
    if @voucher.current_state == :accepted
      @voucher.assignee_id = nil
    else    
      @voucher.assignee_id = params[:voucher][:assignee_id]
    end
    @voucher.save!
    redirect_to :back
  end
 
  def decrement_state
     @voucher = Voucher.find(params[:id])
    case "#{@voucher.current_state}"
      when "pending" then @voucher.reject!
      when "approved" then @voucher.reject!
    end
    @voucher.assignee_id = @voucher.creator_id
    @voucher.save!
    redirect_to :back
  end
  
  protected
    # Use callbacks to share common setup or constraints between actions.
    def set_voucher
      @voucher = Voucher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voucher_params
      params.require(:voucher).permit(:date,:from_date,:to_date,:payment_reference,:assignee_id,:account_debited,:account_credited,:amount,:payment_type,uploads_attributes:[:avatar,:id,:_destroy],comments_attributes:[:description,:id,:_destroy,:user_id])
    end
  
end
