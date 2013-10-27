class AddStatusToVouchers < ActiveRecord::Migration
  def change
    #FIXME_AB: formatting and indentation. do proper spacing 
  	add_column :vouchers, :status, :integer,default:1 
  end
end
