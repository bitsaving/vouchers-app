class Account < ActiveRecord::Base
  has_many :transactions
  has_many :vouchers_debited ,-> { where(:transactions => { account_type: "debit" }) } ,through: :transactions,source: :voucher#:class_name=>'Voucher' , :foreign_key => 'account_debited' 
  has_many :vouchers_credited ,-> { where(:transactions => { account_type: "credit" }) } , through: :transactions,source: :voucher#:class_name=>"Voucher" , :foreign_key => 'account_credited' 
  #has_many :vouchers, through: :transactions
  validates_uniqueness_of :name  , :case_sensitive => false
  default_scope { order('name') }
  paginates_per 50
  before_validation :strip_blanks

  #FIXME_AB: Why do you have used a block instead of a method for before_destroy. 
  before_destroy do 
  	errors.add :base , "We are not allowing destroy or delete for Account" 
  	return false 
  end	

  def delete
  	errors.add :base , "We are not allowing destroy or delete for Account" 
  	return false 
  end

  def strip_blanks
    self.name = self.name.squish
  end

end
