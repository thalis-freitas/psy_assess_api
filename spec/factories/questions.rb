FactoryBot.define do
  factory :question do
    text { Faker::Lorem.question }
    instrument

    trait :with_options do
      after(:create) do |question|
        create(:option, question:, score_value: 3,
                        text: Faker::Lorem.sentence(word_count: 2))

        create(:option, question:, score_value: 2,
                        text: Faker::Lorem.sentence(word_count: 2))

        create(:option, question:, score_value: 1,
                        text: Faker::Lorem.sentence(word_count: 2))

        create(:option, question:, score_value: 0,
                        text: Faker::Lorem.sentence(word_count: 2))
      end
    end
  end
end
