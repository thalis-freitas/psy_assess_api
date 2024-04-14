FactoryBot.define do
  factory :evaluation do
    evaluated { association :user }
    instrument
  end
end
