FactoryBot.define do
  factory :instrument do
    name { "Instrument #{Faker::Lorem.sentence}" }
    description { Faker::Lorem.paragraph }

    trait :with_questions do
      after(:create) do |instrument|
        create_list(:question, 5, instrument: instrument) do |question|
          create_list(:option, 4, question: question)
        end
      end
    end
  end
end
