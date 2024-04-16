FactoryBot.define do
  factory :option do
    question
    text { Faker::Lorem.sentence(word_count: 2) }
    score_value { rand(0..3) }
  end
end
