require 'factory_girl'

FactoryGirl.define do
  factory :voucher do
  	date Date.today
  	association :assignee, factory: :user, email: "abc@vinsol.com"
    creator_id { User.find_by_email("divya@vinsol.com").id }
  	workflow_state "drafted"
    factory :voucher_with_comments do
       ignore do
        comments_count 5
      end
      after(:create) do |voucher, evaluator|
        create_list(:comment, evaluator.comments_count, voucher: voucher)
      end
    end
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
    factory :voucher_with_debited_transactions do
       ignore do
        debited_transactions_count 5
      end
      after(:create) do |voucher, evaluator|
        create_list(:transaction, evaluator.debited_transactions_count, voucher:voucher)
      end
    end
    factory :voucher_with_credited_transactions do
       ignore do
        credited_transactions_count 5
      end
      after(:create) do |voucher, evaluator|
        create_list(:transaction, evaluator.credited_transactions_count, voucher:voucher)
      end
    end
  end
end