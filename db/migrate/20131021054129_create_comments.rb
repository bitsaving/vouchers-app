class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
   	  t.text :description  	
      t.references :user , index: true
      t.references :voucher , index: true
      t.timestamps
    end
  end
end
