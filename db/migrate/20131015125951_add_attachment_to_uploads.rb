class AddAttachmentToUploads < ActiveRecord::Migration
  def self.up
    change_table :uploads do |t|
      #FIXME_AB: I am not sure why we need avatar
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :uploads, :avatar
  end
end
