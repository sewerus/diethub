FactoryBot.define do
  factory :patient do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password {}
  end
end