FactoryGirl.define do

  factory User do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@nyu.edu" }
    user_attributes {{ :some_field => "test" }}
  end


end
