
class Attachment < ActiveRecord::Base
  belongs_to :voucher 
  #FIXME_AB: Attachment could be anything. So name it as attachment not bill_attachment.
  # has_attached_file :bill_attachment, :url =>"/assets/vouchers/:id/:style/:basename.:extension", :path => ":rails_root/public/assets/vouchers/:id/:style/:basename.:extension"
  has_attached_file :bill_attachment, :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  def s3_credentials
    { :bucket => bucket, :access_key_id => access_key, :secret_access_key => secret_access }
  end
  
end
