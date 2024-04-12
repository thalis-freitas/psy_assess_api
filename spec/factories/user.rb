FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Lorem.word }

    trait :psychologist do
      role { :psychologist }
    end
  end
end
