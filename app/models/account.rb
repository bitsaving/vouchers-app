class Account < ActiveRecord::Base
  has_many :vouchers,:dependent=>:destroy
  validates :name,presence: true
  validates :name ,uniqueness: true
  ACCOUNT_TYPES = ["debit" ,"credit"]
end
