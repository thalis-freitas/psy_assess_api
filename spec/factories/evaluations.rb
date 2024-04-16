FactoryBot.define do
  factory :evaluation do
    evaluated { association :user }
    instrument
    status { 'pending' }

    trait :sent do
      status { 'sent' }
      token { SecureRandom.hex(10) }
    end

    trait :in_progress do
      status { 'in_progress' }
      token { SecureRandom.hex(10) }
    end

    trait :finished do
      status { 'finished' }
      score { rand(1..10) } # Supõe que a pontuação máxima seja 10
      token { SecureRandom.hex(10) }
    end
  end
end
