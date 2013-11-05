class NotificationsController < ApplicationController
  def index
  	@notifications = PublicActivity::Activity.where('owner_id = ?', current_user.id).order("created_at desc")  
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

end
