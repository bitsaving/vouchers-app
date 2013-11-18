class RenameAttachment < ActiveRecord::Migration
  def change
  	rename_column :uploads , :avatar_file_name , :bill_attachment_file_name
  	rename_column :uploads , :avatar_content_type , :bill_attachment_content_type
  	rename_column :uploads , :avatar_file_size , :bill_attachment_file_size
  	rename_column :uploads , :avatar_updated_at , :bill_attachment_updated_at
  end
end
