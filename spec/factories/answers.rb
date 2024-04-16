FactoryBot.define do
  factory :answer do
    evaluation
    question
    option
    score { rand(0..3) }
  end
end
