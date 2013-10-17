class Upload < ActiveRecord::Base

belongs_to :voucher
has_attached_file :avatar, :default_url => ActionController::Base.helpers.asset_path('missing.png'),:url =>"/assets/vouchers/:id/:style/:basename.:extension",:path=>":rails_root/public/assets/vouchers/:id/:style/:basename.:extension"
#attr_accessor :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at,:account_name
 #has_attached_file :avatar, :styles => { :large=> "200x200>", :medium => "100x100>", :thumb => "25x25>" }#, :default_url => ActionController::Base.helpers.asset_path('missing.png')
  # validates_attachment_presence :avatar #:if radiobuttonselected
  validates_attachment_size :avatar,:less_than =>5.megabytes
 validates_attachment_content_type :avatar,:content_type =>'application/pdf' 
end
