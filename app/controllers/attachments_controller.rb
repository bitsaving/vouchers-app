class AttachmentsController < ApplicationController

  before_action :set_attachment, only: [:download]


  def download
    redirect_to @attachment.bill_attachment.expiring_url(60)

  end

  def set_attachment

    @attachment = Attachment.find_by(id: params[:id])
    Rails.logger.debug "!!@@#{@attachment}"
  end

end