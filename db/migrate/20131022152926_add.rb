class Add < ActiveRecord::Migration
  def change
  		add_column :vouchers, :reference, :string 
  end
end
