class CommentsController < ApplicationController
 
  before_action :set_comment, only: [:destroy]
  before_action :set_voucher, only: [:create]
  
  def create
    @comment = @voucher.comments.build(comment_params)
    if @comment.save
      respond_to do |format|
        format.html { redirect_to_back_or_default_url }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to_back_or_default_url, notice: "Comment could not be added because there was no content in it" }
        format.js
      end
    end
  end

  private
 
  def set_comment
    @comment = Comment.find_by(id: params[:id])
    redirect_to_back_or_default_url, notice: "Comment not found" if @comment.nil?
  end

  def set_voucher
    @voucher = Voucher.find(params[:voucher_id])
    redirect_to_back_or_default_url, notice: "Voucher not found" if @voucher.nil?  
  end   

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:description).merge({ user_id: current_user.id, voucher_id: params[:voucher_id] })
  end

end