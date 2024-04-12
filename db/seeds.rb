User.create!(email: 'debora@psy_assess.com',
             password: 'password',
             role: :psychologist)

FactoryBot.create_list(:user, 10)
