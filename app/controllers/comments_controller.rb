class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  def create
    #FIXME_AB: I think a better way to do is find voucher first and then do voucher.comments.build
    @comment = Comment.new(comment_params)
    if(@comment.save)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js { @voucher = Voucher.find(params[:voucher_id])}
      end
    else
      respond_to do |format|
        format.html do
          redirect_to :back
          #FIXME_AB: It would be good if you can also display specific error, why comment was not saved
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
  def comment_params
    params.permit(:description,:accepted,:voucher_id).merge({ user_id: current_user.id })
  end
end