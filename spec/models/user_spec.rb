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
  end
end
