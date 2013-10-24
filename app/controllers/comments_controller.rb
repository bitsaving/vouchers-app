class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :set_user ,only: [:create]
  def create
     @comment = Comment.new(comment_params)
     if(@comment.save)
      respond_to do |format|
        format.html { redirect_to :back }
      end
    end
  end

  def destroy
    if(@comment.destroy)
      respond_to do |format|
        format.html { redirect_to :back }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.permit(:description,:accepted,:voucher_id,:user_id)
    end
  
    def set_user
      params[:user_id] = current_user.id
    end

end

