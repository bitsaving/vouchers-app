#FIXME_AB: Lets not allow account to be delete for now. Even I do account.destroy from console, it should not be destroyed. there should not be any way to delete an account
class Account < ActiveRecord::Base

  has_many :vouchers,:dependent=>:destroy
  validates :name,presence: true
  #FIXME_AB: Uniqueness is not case sensitive please handle
  validates :name ,uniqueness: true

  #FIXME_AB: Since this is Account model itself, why we need to name it as ACCOUNT_TYPES, we can name it as TYPES only so that we can access Account::TYPES
  #FIXME_AB: Also why we need this array
  ACCOUNT_TYPES = ["debit" ,"credit"]
end
