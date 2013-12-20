class RemoveColumnFromVouchers < ActiveRecord::Migration
  def change
    remove_column :vouchers, :amount, :integer
    remove_column :vouchers, :payment_type, :integer
    remove_column :vouchers, :payment_reference, :integer
    remove_column :vouchers, :account_debited, :integer

    remove_column :vouchers, :account_credited, :integer
    remove_column :vouchers, :transfer_from_id, :integer
    remove_column :vouchers, :transfer_to_id, :integer   
  end
end
