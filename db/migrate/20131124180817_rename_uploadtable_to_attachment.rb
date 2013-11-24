class RenameUploadtableToAttachment < ActiveRecord::Migration
  def change
  	rename_table :uploads, :attachments
  end
end
