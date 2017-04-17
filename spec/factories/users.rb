FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    encrypted_password "encrypted_password"
  end
end
