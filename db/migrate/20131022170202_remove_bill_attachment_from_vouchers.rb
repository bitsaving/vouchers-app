class RemoveBillAttachmentFromVouchers < ActiveRecord::Migration
  def change
  	remove_column :vouchers, :bill_attachment , :boolean
  end
end
