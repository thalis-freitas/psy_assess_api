FactoryBot.define do
  factory :option do
    question
    text { Faker::Lorem.sentence(word_count: 2) }
  end
end
