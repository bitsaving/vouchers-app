class ChangeColumnsOfVoucher < ActiveRecord::Migration
  def change

  	rename_column :vouchers , :pay_type , :payment_type
  	rename_column  :vouchers , :reference, :payment_reference
  	rename_column :vouchers , :debit_from_id , :account_debited
  	rename_column :vouchers , :credit_to_id , :account_credited
  	rename_column :vouchers , :user_id , :creator_id
  	rename_column :vouchers , :assigned_to_id , :assignee_id	

  	
  end
end
