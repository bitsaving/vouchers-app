class NotificationsController < ApplicationController
  def index
    #FIXME_AB: we should get notification via associations. like current_user.notifications
  	@notifications = PublicActivity::Activity.where('owner_id = ?', current_user.id).order("created_at desc")  
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  #FIXME_AB: You should just name the following action as seen. or mark_read
  def seen_notifications
  	if params[:activity_id]
  		@seen_notification = PublicActivity::Activity.where('id=?',params[:activity_id]).first
      #FIXME_AB: You should do this notification.seen! which will mark it true and saves it.
 		  @seen_notification.seen = true
 		  @seen_notification.save!
 	  end
    #FIXME_AB: Any specific reason that you are rendering vouchers_path as text
 	  render text: voucher_path(params[:voucher_id])
  end
end
