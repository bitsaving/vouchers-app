class AddDeletedAtToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :deleted_at, :time
  end
end
