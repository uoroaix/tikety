# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket do
    association :user, factory: :user
    title Faker::Company.bs
    description Faker::Lorem.sentence
    status false
  end
end
