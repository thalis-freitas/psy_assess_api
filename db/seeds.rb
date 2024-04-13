User.create!(name: 'Débora Nascimento',
             email: 'debora@psy.assess',
             password: 'password',
             role: :psychologist)

FactoryBot.create_list(:user, 10)
