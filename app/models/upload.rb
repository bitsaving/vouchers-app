class Upload < ActiveRecord::Base
  belongs_to :voucher 
  has_attached_file :avatar, :url =>"/assets/vouchers/:id/:style/:basename.:extension",:path=>":rails_root/public/assets/vouchers/:id/:style/:basename.:extension"
  validates_attachment_size :avatar,:less_than =>5.megabytes
  validates_attachment_content_type :avatar,:content_type =>'application/pdf' 
  
end
