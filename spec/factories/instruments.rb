FactoryBot.define do
  factory :instrument do
    name { "Instrumento #{Faker::Lorem.unique.sentence}" }
    description { Faker::Lorem.paragraph }

    trait :with_questions do
      after(:create) do |instrument|
        create_list(:question, 5, instrument:) do |question|
          create_list(:option, 4, question:)
        end
      end
    end
  end
end
