class CreateTableTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	t.references :voucher
    	t.integer :amount
    	t.string :transaction_type
    	t.string :payment_type
    	t.string :payment_reference
    	t.references :account
    end
  end
end
