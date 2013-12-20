require 'factory_girl'

FactoryGirl.define do
  factory :voucher do
  	date Date.today
  	payment_type "Cheque"
  	payment_reference "abcd"
  	amount "100"
  	debit_from FactoryGirl.build(:account , name: "abc")
  	credit_to FactoryGirl.build(:account ,name: "abcds")
  	creator User.create(email: "abc@vinsol.com" , first_name: "abc",last_name:"xyz")
  	workflow_state "drafted"
  end
end