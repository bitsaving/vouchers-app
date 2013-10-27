class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :set_user ,only: [:create]
  def create
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
  
    #FIXME_AB: It is not the right way to set user
    def set_user
      params[:user_id] = current_user.id
    end

end

