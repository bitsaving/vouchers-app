class Account < ActiveRecord::Base
  has_many :vouchers	
  validates :name,presence: true
  validates :name ,uniqueness: true
end
