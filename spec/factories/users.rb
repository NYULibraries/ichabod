FactoryGirl.define do

  factory User do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "#{username}@example.com" }
  end

end
