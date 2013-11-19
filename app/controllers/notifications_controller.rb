class NotificationsController < ApplicationController
  def index
    #FIXME_AB: Instead of defining order again and again you can make a scope or a default scope
    @notifications = current_user.notifications.order('created_at desc')
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

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
