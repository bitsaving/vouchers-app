class VouchersController < ApplicationController
    include CurrentUser
    before_action :authorize
  before_action :set_voucher, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:new, :create]
  # GET /vouchers
  # GET /vouchers.json
  def index
    @vouchers = Voucher.where(user_id: @user)
  end

  # GET /vouchers/1
  # GET /vouchers/1.json
  def show
  end

 

  # GET /vouchers/new
  def new
    @voucher = Voucher.new
    question = @voucher.uploads.build
  end

  # GET /vouchers/1/edit
  def edit
  end

  # POST /vouchers
  # POST /vouchers.json
  def create
   @voucher = @user.vouchers.build(voucher_params)
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

  # DELETE /vouchers/1
  # DELETE /vouchers/1.json
  def destroy
    @voucher.destroy
    respond_to do |format|
      format.html { redirect_to vouchers_url }
      format.json { head :no_content }
    end
  end

  def delete_attachment
    @voucher.avatar.clear
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voucher
      @voucher = Voucher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voucher_params
      params.require(:voucher).permit(:date,:from_date,:to_date,:credit_to_id,:debit_from_id,:amount,uploads_attributes:[:avatar])
    end
end
