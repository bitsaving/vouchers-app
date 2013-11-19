class Upload < ActiveRecord::Base
  belongs_to :voucher 
  has_attached_file :bill_attachment , :url =>"/assets/vouchers/:id/:style/:basename.:extension" , :path=>":rails_root/public/assets/vouchers/:id/:style/:basename.:extension"
  validates_attachment_size :bill_attachment , :less_than => 5.megabytes
  # validates_attachment_content_type :avatar,:content_type =>'application/pdf' 

  before_save :rename_file
  #FIXME_AB: You have code formatting issue. YOu should install beautifyRuby sublime package and use them.

  #FIXME_AB: I am not sure why this method is needed, please explain
  #this is required to replace the filename with the caption added.
  def rename_file
	  if bill_attachment_file_name
      extension = File.extname(bill_attachment_file_name).downcase
      if !tagname.blank?
        self.bill_attachment.instance_write :file_name , "#{tagname}#{extension}"
      end  
    end
  end
end
