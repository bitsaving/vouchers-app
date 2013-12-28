class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications
  end

  def seen
  	if params[:activity_id]
  		@seen_notification = PublicActivity::Activity.where('id=?', params[:activity_id]).first
      @seen_notification.seen!
	  end
 	  render text: voucher_path(params[:voucher_id])
  end
end
