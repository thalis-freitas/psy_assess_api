FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    cpf { Faker::IdNumber.unique.brazilian_citizen_number }
    email { Faker::Internet.unique.email }
    birth_date { Faker::Date.birthday(min_age: 10, max_age: 100) }

    trait :psychologist do
      password { Faker::Lorem.word }
      role { :psychologist }
    end
  end
end
