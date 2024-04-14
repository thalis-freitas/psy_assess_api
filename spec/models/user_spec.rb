require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'role enum' do
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

  describe '#valid' do
    context 'presence' do
      it 'name field is required' do
        user = User.new(name: '')

        user.valid?

        expect(user.errors.include?(:name)).to be true
        expect(user.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'email field is required' do
        user = User.new(email: '')

        user.valid?

        expect(user.errors.include?(:email)).to be true
        expect(user.errors[:email]).to include 'não pode ficar em branco'
      end

      it 'cpf field is required' do
        user = User.new(cpf: '')

        user.valid?

        expect(user.errors.include?(:cpf)).to be true
        expect(user.errors[:cpf]).to include 'não pode ficar em branco'
      end

      it 'birth_date field is required' do
        user = User.new(birth_date: '')

        user.valid?

        expect(user.errors.include?(:birth_date)).to be true
        expect(user.errors[:birth_date]).to include 'não pode ficar em branco'
      end
    end

    context 'uniqueness' do
      it 'should validate uniqueness of cpf' do
        create(:user, cpf: '12345678900')
        new_user = build(:user, cpf: '12345678900')

        new_user.valid?

        expect(new_user.errors.include?(:cpf)).to be true
        expect(new_user.errors[:cpf]).to include 'já está em uso'
      end

      it 'should validate uniqueness of email' do
        create(:user, email: 'test@example.com')
        new_user = build(:user, email: 'test@example.com')

        new_user.valid?

        expect(new_user.errors.include?(:email)).to be true
        expect(new_user.errors[:email]).to include 'já está em uso'
      end
    end
  end

  describe '#birth_date' do
    it 'formats the birth_date to dd/mm/yyyy' do
      user = build(:user, birth_date: '2000-01-01')

      expect(user.birth_date).to eq '01/01/2000'
    end
  end

  describe '#validate_birth_date_cannot_be_future' do
    it 'adds an error if birth_date is in the future' do
      user = build(:user, birth_date: Date.tomorrow.to_s)

      user.valid?

      expect(user.errors[:birth_date]).to include('não pode ser futura')
    end
  end

  describe 'associations' do
    it 'should have many evaluations' do
      user = User.new
      expect(user).to respond_to(:evaluations)
    end
  end
end
