class CreateUploads < ActiveRecord::Migration
  def change
    #FIXME_AB: instead of uploads we can name it better. Something like documents or attachments
    create_table :uploads do |t|
   	  t.references :voucher
      t.timestamps
    end
  end
end
