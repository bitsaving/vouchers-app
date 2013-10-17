class Voucher < ActiveRecord::Base 
	PAYMENT_TYPES = [ "Check", "Credit card", "Bank transfers" ]
  
  #  belongs_to :debit_from, :class_name => 'Account'
  # belongs_to :credit_to, :class_name => 'Account'
  # belongs_to :account
  # belongs_to :debit_from, :class_name => 'Account'
  #  belongs_to :credit_to, :class_name => 'Account'
  #   belongs_to :transfer_from, :class_name => 'BankAccount'
  # belongs_to :transfer_to, :class_name => 'BankAccount'
  belongs_to :user#
  has_many :uploads
  accepts_nested_attributes_for :uploads#, allow_destroy: true,update_only: true
 

  # def account_name

  #   #debit_from_id = account.id if account
  
  #   account.name if account
  # end
  # def account_name=(name)
  #   self.account = Account.find_or_create_by_name(name) unless name.blank?
  # #debit_from_id = account.id 
  # end
end
#<%= link_to @data.data_file_name, @data.url %>