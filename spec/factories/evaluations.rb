FactoryBot.define do
  factory :evaluation do
    evaluated { association :user }
    instrument
    # score { 1 }
    # token { 'MyString' }
  end
end
