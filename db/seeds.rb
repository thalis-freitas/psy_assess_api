User.create!(name: 'Débora Nascimento',
             email: 'debora@psy.assess',
             password: 'password',
             role: :psychologist)

evaluated = FactoryBot.create(:user)
instrument = FactoryBot.create(:instrument, :with_questions)
instrument2 = FactoryBot.create(:instrument, :with_questions)
instrument3 = FactoryBot.create(:instrument, :with_questions)
instrument4 = FactoryBot.create(:instrument, :with_questions)

FactoryBot.create(:evaluation, evaluated:, instrument:)
FactoryBot.create(:evaluation, :sent, evaluated:, instrument: instrument2)
FactoryBot.create(:evaluation, :in_progress, evaluated:, instrument: instrument3)
FactoryBot.create(:evaluation, :finished, evaluated:, instrument: instrument4)

FactoryBot.create_list(:user, 10)
FactoryBot.create_list(:instrument, 10, :with_questions)
