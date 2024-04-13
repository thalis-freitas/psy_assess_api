FactoryBot.define do
  factory :question do
    text { "Question #{Faker::Lorem.question}" }
    instrument

    trait :with_options do
      after(:create) do |question|
        create(:option, question:, score_value: 3)
        create(:option, question:, score_value: 2)
        create(:option, question:, score_value: 1)
        create(:option, question:, score_value: 0)
      end
    end
  end
end
