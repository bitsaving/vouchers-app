class CreateTableTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	t.references :voucher
    	t.integer :amount
    	t.string :account_type
    	t.string :pay_type
    	t.string :reference
    	t.references :account
    end
  end
end
