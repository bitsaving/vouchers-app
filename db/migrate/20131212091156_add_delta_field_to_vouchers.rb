class AddDeltaFieldToVouchers < ActiveRecord::Migration
  def change
	add_column :vouchers, :delta, :boolean, :default => true, :null => false
  end
end
