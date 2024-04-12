require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Role enum' do
    it 'should define correct roles' do
      expect(User.roles.keys).to contain_exactly('psychologist', 'evaluated')
    end

    it 'should have default role as evaluated' do
      user = User.new
      expect(user.role).to eq('evaluated')
    end

    it 'should assign default password as cpf for evaluated' do
      user = create(:user)
      expect(user.authenticate(user.cpf)).to be_truthy
    end

    it 'should not assign default password as CPF for psychologists' do
      user = create(:user, :psychologist)
      expect(user.authenticate(user.cpf)).to be_falsey
    end
  end
end
