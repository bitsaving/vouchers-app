class VouchersController < ApplicationController
  # include CurrentUser
  before_action :authorize
  before_action :set_voucher, only: [:show, :edit, :update, :destroy]
 before_action :set_user_for_comments ,only: :create
 
  # GET /vouchers
  # GET /vouchers.json
  def index
    @vouchers = Voucher.where(user_id: current_user.id).page(params[:page]).per(15)
  end

  # GET /vouchers/1
  # GET /vouchers/1.json
  def show
  end




  # GET /vouchers/new
  def new
    
    @voucher = Voucher.new
    uploads = @voucher.uploads.build
    comments =@voucher.comments.build
  end

  # GET /vouchers/1/edit
  def edit  
  end

  # POST /vouchers
  # POST /vouchers.json
  def create
   @voucher = Voucher.new(voucher_params)
    current_user.vouchers << @voucher
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
    @vouchers = Voucher.where(workflow_state: 'pending').where(user_id: current_user.id).all
    render :json => @vouchers
  end
  def waiting_for_approval
    @vouchers = Voucher.where.not(workflow_state: 'accepted').where(assigned_to_id: current_user.id).page(params[:page])
    respond_to do |format|
      format.html { render action: 'index' }
   end
  end
# end
#  def accepted_vouchers
#     @vouchers = Voucher.find_by_status(current_user.worth + 2).page(params[:page]).per(15)
#    
# end
#  def rejected_vouchers
#     @vouchers = Voucher.find_by_status(current_user.worth)
#     respond_to do |format|
#       format.html { render action: 'index' }
#   end
# end
  # DELETE /vouchers/1
  # DELETE /vouchers/1.json
  def destroy
    @voucher.destroy
    respond_to do |format|
      format.html { redirect_to vouchers_url }
      format.json { head :no_content }
    end
  end
  def change_status
    @voucher = Voucher.find(params[:id])
    @voucher.send_for_approval!
    @voucher.assigned_to_id = params[:voucher][:assigned_to_id]
    @voucher.save!
    redirect_to new_user_session_path
  end
  protected
    # Use callbacks to share common setup or constraints between actions.
    def set_voucher
      @voucher = Voucher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voucher_params
      params.require(:voucher).permit(:date,:from_date,:to_date,:reference,:assigned_to_id,:credit_to_id,:debit_from_id,:amount,:pay_type,:assigned_to_id,uploads_attributes:[:avatar,:id,:_destroy],comments_attributes:[:description,:id,:_destroy,:user_id])
   
    end
    def set_user_for_comments
      
     params["voucher"]["comments_attributes"]["0"]["user_id"] = current_user.id
     if params["voucher"]["uploads_attributes"]["0"].length == 1
      params["voucher"]["uploads_attributes"]["0"]["_destroy"]=true
    end
  end
  
end
