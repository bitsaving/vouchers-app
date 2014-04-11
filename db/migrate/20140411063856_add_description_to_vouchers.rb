class AddDescriptionToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :description, :text
  end
end
