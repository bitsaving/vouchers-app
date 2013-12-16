require 'factory_girl'

FactoryGirl.define do
  factory :voucher do
  	date Date.today
  	payment_type "Cheque"
  	payment_reference "abcd"
  	amount "100"
  	debit_from Account.create(name: "abc")
	credit_to Account.create(name: "abcds")
	creator User.create(email: "abc@vinsol.com" , first_name: "abc",last_name:"xyz")
	workflow_state "drafted"
  end
end