class AddStatusToVouchers < ActiveRecord::Migration
  def change
  	add_column :vouchers, :status, :integer,default:1 
  end
end
