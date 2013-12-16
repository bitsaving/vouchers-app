class Account < ActiveRecord::Base
  has_many :transactions
  has_many :vouchers_debited ,-> { where(:transactions => { account_type: "debit" }) } ,through: :transactions,source: :voucher#:class_name=>'Voucher' , :foreign_key => 'account_debited' 
  has_many :vouchers_credited ,-> { where(:transactions => { account_type: "credit" }) } , through: :transactions,source: :voucher#:class_name=>"Voucher" , :foreign_key => 'account_credited' 
  #has_many :vouchers, through: :transactions
  validates_uniqueness_of :name  , :case_sensitive => false
  default_scope { order('name') }
  paginates_per 50
  #FIXME_AB: Good. But This will return false when I call obj.destroy. Lets do one more thing add error to the object :base. "We are not allowing destroy or delete for Account". Do the same thing for delete. since obj.delete will delete the object. delete don't fire callbacks to you would need to overwite delete method in he model
  #fixed
  before_validation :strip_blanks
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

  #FIXME_AB: Since this is needed for dropdown and not belongs to Account. Move it to constant.rb in initializers. And name it ACCOUNT_FILTER_OPTIONS or something similar
  #fixed
end
