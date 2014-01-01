class ChnagecolumnOfTransaction < ActiveRecord::Migration
  def change
    rename_column :transactions, :account_type , :transaction_type
  end
end
