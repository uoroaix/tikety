FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "some_email#{n}@awesomeanswers.com" }
    password Faker::Internet.password(10)
  end
end