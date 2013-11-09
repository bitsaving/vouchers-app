class NotificationsController < ApplicationController
  def index
  	@notifications = PublicActivity::Activity.where('owner_id = ?', current_user.id).order("created_at desc")  
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end
  def seen_notifications
  	if params[:activity_id]
  		@seen_notification = PublicActivity::Activity.where('id=?',params[:activity_id]).first
 		  @seen_notification.seen = true
 		  @seen_notification.save!
 	  end
 	  render text: voucher_path(params[:voucher_id])
  end
end
