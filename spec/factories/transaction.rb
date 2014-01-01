require 'factory_girl'

FactoryGirl.define do
  factory :transaction do
    account_id "2"
    transaction_type "debit"
    amount "100"
  end
end