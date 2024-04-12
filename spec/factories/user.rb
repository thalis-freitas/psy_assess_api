FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    cpf { Faker::IDNumber.brazilian_citizen_number }
    email { Faker::Internet.unique.email }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }

    trait :psychologist do
      password { Faker::Lorem.word }
      role { :psychologist }
    end
  end
end
