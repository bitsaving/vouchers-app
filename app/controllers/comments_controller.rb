class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  
  def create
<<<<<<< HEAD
    @comment = Comment.new(comment_params)
    if(@comment.save)
      respond_to do |format|
        format.html { redirect_to :back }
      end
    else
=======
<<<<<<< HEAD
    @comment = Comment.new(comment_params)
    if(@comment.save)
      respond_to do |format|
        format.html { redirect_to :back }
      end
    else
=======
     @comment = Comment.new(comment_params)
     #FIXME_AB: What would happen if comment is not saved
     if(@comment.save)
      respond_to do |format|
        format.html { redirect_to :back }
      end
    end
  end

  def destroy
    #FIXME_AB: @comment.destroy would always return true, how would you ensure that it is destroyed.
    if(@comment.destroy)
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
      respond_to do |format|
        format.html do 
          redirect_to :back
          flash[:notice] = "Comment could not be added"
        end
        format.js do
        end
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :back
  end

    # Never trust parameters from the scary internet, only allow the white list through.
<<<<<<< HEAD
  def comment_params
    params.permit(:description,:accepted,:voucher_id).merge({ user_id: current_user.id })
  end
  
=======
<<<<<<< HEAD
  def comment_params
    params.permit(:description,:accepted,:voucher_id).merge({ user_id: current_user.id })
  end
=======
    def comment_params
      params.permit(:description,:accepted,:voucher_id,:user_id)
    end
  
    #FIXME_AB: It is not the right way to set user
    def set_user
      params[:user_id] = current_user.id
    end

>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
end


