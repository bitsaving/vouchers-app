class AddAttachmentToUploads < ActiveRecord::Migration
  def self.up
    change_table :uploads do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :uploads, :avatar
  end
end
