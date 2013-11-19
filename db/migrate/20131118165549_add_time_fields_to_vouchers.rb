class AddTimeFieldsToVouchers < ActiveRecord::Migration
  def change
  	add_column :vouchers ,:accepted_at,:datetime
  	add_column :vouchers ,:approved_at,:datetime
  end
end
