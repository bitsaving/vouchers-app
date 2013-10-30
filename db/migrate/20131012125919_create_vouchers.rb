class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.date :date
      #FIXME_AB: What does this pay_type stands for? If it is the type of payment like cash, cheque the it should be payment type. 
      #FIXME_AB: Also it would be good if we can limit the string length. In this case it should be 15-20 chars
      t.string :pay_type
<<<<<<< HEAD
      t.boolean :bill_attachment
      t.references :debit_from , index: true
      t.references :credit_to , index: true
      t.references :user , index: true
      t.date :from_date
      t.date :to_date
      t.decimal :amount , precision: 8 , scale: 2
      t.references :transfer_from , index: true
      t.references :transfer_to , index: true
      t.references :assigned_to , index:true
=======
<<<<<<< HEAD
      t.boolean :bill_attachment
      t.references :debit_from , index: true
      t.references :credit_to , index: true
      t.references :user , index: true
      t.date :from_date
      t.date :to_date
      t.decimal :amount , precision: 8, scale: 2
      t.references :transfer_from , index: true
      t.references :transfer_to , index: true
      t.references :assigned_to , index:true
=======
      #FIXME_AB: This column should be payment_reference
      t.string :reference
      #FIXME_AB: We don't need bill_attachment. If you think we need it, please convence me
      t.boolean :bill_attachment
      #FIXME_AB: debit_from should be account_debited
      t.references :debit_from ,index: true
      #FIXME_AB: Should be account_credited
      #FIXME_AB: Please follow all the learnings you get in training. You should have space after comma and operators. Remember? :-)
      t.references :credit_to,index: true
      #FIXME_AB: This should be creator_id
      t.references :user,index: true
      t.date :from_date
      t.date :to_date
      t.decimal :amount , precision: 8, scale: 2
      #FIXME_AB: I am not sure if we need transfer_from and transfer_to
      t.references :transfer_from,index: true
      t.references :transfer_to,index: true
      #FIXME_AB: this should be assignee_id
      t.references :assigned_to,index:true
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
      t.timestamps
    end
  end
end
