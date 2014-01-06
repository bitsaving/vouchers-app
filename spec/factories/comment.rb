require 'factory_girl'

FactoryGirl.define do
  factory :comment do
    description "abcdeg"
    voucher_id 2
    user_id { User.find_by_email("divya@vinsol.com").id }
  end
end