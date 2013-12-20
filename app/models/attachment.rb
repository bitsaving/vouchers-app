class Attachment < ActiveRecord::Base
  belongs_to :voucher 
  #FIXME_AB: Attachment could be anything. So name it as attachment not bill_attachment.
  has_attached_file :bill_attachment, :url =>"/assets/vouchers/:id/:style/:basename.:extension", :path => ":rails_root/public/assets/vouchers/:id/:style/:basename.:extension"
end
