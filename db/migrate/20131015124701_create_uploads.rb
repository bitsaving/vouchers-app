class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
   	  t.references :voucher
   
      t.timestamps
    end
  end
end
