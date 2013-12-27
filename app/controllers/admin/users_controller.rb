class Admin::UsersController < Admin::AdminBaseController
  #  cache_sweeper :user_sweeper, only: [:update, :destroy]
  before_action :set_user, :only => [:edit,:destroy, :update, :show]
  #FIXME_AB: Following before_action can be moved to AdminBaseController if we follow the approach I mentioned in the first line of this file
  
  #FIXME_AB: we can also name check_admin as authorize_as_admin
  #before_action :authorize_as_admin
  #caches_action :show

  def index
    @users = User.order('first_name').page(params[:page])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: @user.name + ' was successfully created.' }
        format.json { render action: 'show', status: :created, location: @voucher }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to [:admin, @user], notice: @user.name + ' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  #FIXME_AB: I don't think we need this action. Please remove if we need it


  def destroy
    redirect_to admin_users_path ,notice: "Sorry it cannot be deleted"
  end

  protected
  
    def user_params
      params.require(:user).permit(:first_name, :last_name, :user_type, :email)
    end

    def set_user
      @user = User.find_by(id: params[:id])
      redirect_to_back_or_default_url if @user.nil?
    end
end