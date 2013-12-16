class Transaction < ActiveRecord::Base
	belongs_to :account
	belongs_to :voucher
	validates :account_id , :amount , :presence => true
	validates :amount, numericality: { greater_than: 0.00 }
end