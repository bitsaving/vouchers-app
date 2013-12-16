class Transaction < ActiveRecord::Base
	belongs_to :account
	belongs_to :voucher
	validates :account_id , :amount , :presence => true
	validates :amount, numericality: { greater_than: 0.00 }
	validates :payment_type , presence: true
	#validates :payment_reference, :presence  => { :message =>" cannot be blank" }, :unless => Proc.new { |a| a['payment_type'] == "Cash" }
end