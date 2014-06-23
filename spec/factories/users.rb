FactoryGirl.define do

  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@nyu.edu" }
    user_attributes {{ :some_field => "test" }}

    factory :gis_cataloger do
      username "gis_admin"
    end
  end


end
