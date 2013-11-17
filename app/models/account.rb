#FIXME_AB: Lets not allow account to be delete for now. Even I do account.destroy from console, it should not be destroyed. there should not be any way to delete an account
#Fixed
class Account < ActiveRecord::Base
  has_many :vouchers_debited , :class_name=>'Voucher' , :foreign_key => 'account_debited' 
  has_many :vouchers_credited ,:class_name=>"Voucher" , :foreign_key => 'account_credited' 
  validates :name , presence: true 
  #FIXME_AB: Uniqueness is not case sensitive please handle
  #Fixed
  validates :name , uniqueness: true , :case_sensitive => false
  before_destroy { return false }
 #FIXME_AB: Since this is Account model itself, why we need to name it as ACCOUNT_TYPES, we can name it as TYPES only so that we can access Account::TYPES
  #Fixed
  #FIXME_AB: Also why we need this array
  #it is required for the credit debit dropdown
  TYPES = ["debit" ,"credit"]
end
