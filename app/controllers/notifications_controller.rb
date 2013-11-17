class NotificationsController < ApplicationController
  def index
    #FIXME_AB: we should get notification via associations. like current_user.notifications
  	#fixed
    @notifications = current_user.notifications  
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  #FIXME_AB: You should just name the following action as seen. or mark_read
  #fixed
  def seen
  	if params[:activity_id]
  		@seen_notification = PublicActivity::Activity.where('id=?',params[:activity_id]).first
      #FIXME_AB: You should do this notification.seen! which will mark it true and saves it.
 		  @seen_notification.seen = true
 		  @seen_notification.save!
 	  end
 	  render text: voucher_path(params[:voucher_id])
  end
end
