class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  def create
    @voucher = Voucher.find(params[:voucher_id])
    if(@voucher.nil?)  
      flash[:notice] = "Voucher not found"
      redirect_to :back
      return false
    end
    @comment = @voucher.comments.build(comment_params)
    if(@comment.save)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js {}
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
    @comment = Comment.find_by(id: params[:id])
    if(@comment.nil?)  
        flash[:notice] = "Comment not found"
        redirect_to_back_or_default_url
      end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.permit(:description,:accepted,:voucher_id).merge({ user_id: current_user.id })
  end
end