require 'factory_girl'

FactoryGirl.define do
  factory :voucher do
  	date Date.today
    factory :voucher_with_debit_from do
       ignore do
        debit_from_count 5
      end
      after(:create) do |voucher, evaluator|
        create_list(:account, evaluator.debit_from_count, voucher:voucher)
      end
    end
    factory :voucher_with_credit_to do
       ignore do
        credit_to_count 5
      end
      after(:create) do |voucher, evaluator|
        create_list(:account, evaluator.credit_to_count, voucher:voucher)
      end
    end
    # association :debit_from, factory: :account
    # association :credit_to, factory: :account
  	# debit_from { Account.create(name: "abc")*2 }
  	# credit_to { Account.create(name: "abcds")*2 }
   #  debited_transactions { Transaction.create(amount: "100",account_id: "2", transaction_type: "debit")*2}
   #  credited_transactions {Transaction.create(amount: "100",account_id: "2", transaction_type: "credit")*2}
  	creator_id { User.find_by_email("divya@vinsol.com").id }
  	workflow_state "rejected"
  end
end