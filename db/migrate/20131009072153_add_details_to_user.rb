class AddDetailsToUser < ActiveRecord::Migration
  def change
  	add_column :users ,:type, :string, default: 'normal'
  	add_column :users ,:worth,:integer, default:1
  	add_column :users, :first_name ,:string
  	add_column :users,:last_name,:string
  end
end
