class RemoveStatusFromVouchers < ActiveRecord::Migration
  def change
  	remove_column :vouchers ,:status,:integer
  end
end
