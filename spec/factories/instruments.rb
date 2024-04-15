FactoryBot.define do
  factory :instrument do
    name { "Instrumento #{Faker::Lorem.unique.sentence}" }
    description { Faker::Lorem.paragraph }

    trait :with_questions do
      after(:create) do |instrument|
        create_list(:question, 5, :with_options, instrument:)
      end
    end
  end
end
