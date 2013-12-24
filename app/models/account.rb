class Account < ActiveRecord::Base
  include DisplayConcern
  paginates_per 50
  validates_uniqueness_of :name, :case_sensitive => false
  before_validation :strip_blanks
  before_destroy :prevent_destroy
  has_many :transactions
  has_many :vouchers_debited , -> { where(:transactions => { account_type: "debit" }) }, through: :transactions, source: :voucher
  has_many :vouchers_credited, -> { where(:transactions => { account_type: "credit" }) }, through: :transactions, source: :voucher 
  has_many :vouchers, through: :transactions, source: :voucher
  default_scope { order('name') }  
  
  def prevent_destroy
  	errors.add :base, "We are not allowing destroy or delete for Account" 
  	return false 
  end	

  def delete
  	errors.add :base, "We are not allowing destroy or delete for Account" 
  	return false 
  end
end
