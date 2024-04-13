User.create!(name: 'Débora Nascimento',
             email: 'debora@psy.assess',
             password: 'password',
             role: :psychologist)

FactoryBot.create_list(:user, 10)

FactoryBot.create_list(:instrument, 10, :with_questions)
