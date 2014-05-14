FactoryGirl.define do

  factory User do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "#{username}@example.com" }
    user_attributes {{ :some_field => "test" }}
  end

end
