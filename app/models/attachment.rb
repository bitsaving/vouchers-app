class Attachment < ActiveRecord::Base
  belongs_to :voucher 
  #FIXME_AB: Attachment could be anything. So name it as attachment not bill_attachment.
  has_attached_file :bill_attachment, :url =>"/assets/vouchers/:id/:style/:basename.:extension" , :path=>":rails_root/public/assets/vouchers/:id/:style/:basename.:extension"
  #validates_attachment_size :bill_attachment , :less_than => 5.megabytes
  # validates_attachment_content_type :avatar,:content_type =>'application/pdf' 

  #before_save :rename_file

  # def rename_file
	 #  if bill_attachment_file_name
  #     extension = File.extname(bill_attachment_file_name).downcase
  #     if !tagname.blank?
  #       #FIXME_AB: Why tagname.extension?
  #       #to append the extension after the file name
  #       self.bill_attachment.instance_write :file_name , "#{tagname}#{extension}"
  #     end  
  #   end
  # end
end
