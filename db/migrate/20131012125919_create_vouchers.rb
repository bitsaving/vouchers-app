class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.date :date
      t.string :pay_type
      t.string :reference
      t.boolean :bill_attachment
      t.references :debit_from ,index: true
      t.references :credit_to,index: true
      t.references :user,index: true
      t.date :from_date
      t.date :to_date
      t.decimal :amount , precision: 8, scale: 2
      t.references :transfer_from,index: true
      t.references :transfer_to,index: true
      t.references :assigned_to,index:true
      t.timestamps
    end
  end
end
