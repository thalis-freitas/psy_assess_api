FactoryBot.define do
  factory :option do
    text { Faker::Lorem.sentence }
    question
    score_value { 0 }
  end
end
