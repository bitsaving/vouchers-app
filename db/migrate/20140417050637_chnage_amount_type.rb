class ChnageAmountType < ActiveRecord::Migration
  def change
    change_column :transactions, :amount, :decimal, :precision => 10, :scale => 2
  
  end
end
