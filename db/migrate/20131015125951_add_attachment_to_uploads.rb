class AddAttachmentToUploads < ActiveRecord::Migration
  def self.up
    change_table :uploads do |t|
    
      t.attachment :bill_attachment
    end
  end

  def self.down
    drop_attached_file :uploads, :bill_attachment
  end
end
