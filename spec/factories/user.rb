require 'factory_girl'

FactoryGirl.define do
  factory :user do
    email "divya@vinsol.com"
    first_name "divya"
    last_name "talwar"
    user_type "normal"
  end
end