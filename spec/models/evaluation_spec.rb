require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  describe 'associations' do
    it 'belongs to evaluated' do
      evaluation = Evaluation.new
      expect(evaluation).to respond_to(:evaluated)
    end

    it 'belongs to instrument' do
      evaluation = Evaluation.new
      expect(evaluation).to respond_to(:instrument)
    end
  end

  describe 'status enum' do
    it 'should define correct status' do
      expect(Evaluation.statuses.keys)
        .to contain_exactly('pending', 'sent', 'finished')
    end

    it 'should have default status as pending' do
      evaluation = Evaluation.new
      expect(evaluation.status).to eq('pending')
    end
  end

  describe '#valid' do
    context 'evaluated must be valid role' do
      it 'rejects evaluations where evaluated does not have evaluated role' do
        psychologist = create(:user, :psychologist)
        instrument = create(:instrument)

        evaluation = Evaluation.new(evaluated: psychologist, instrument:)

        expect(evaluation.valid?).to be false
        expect(evaluation.errors[:evaluated])
          .to include(I18n.t('errors.must_be_evaluated_role'))
      end

      it 'accepts evaluations where evaluated has evaluated role' do
        evaluated = create(:user)
        instrument = create(:instrument)

        evaluation = Evaluation.new(evaluated:, instrument:)

        expect(evaluation.valid?).to be true
      end
    end
  end

  describe 'generate token' do
    it 'generates a unique token before creation' do
      evaluation = create(:evaluation, evaluated: create(:user),
                                       instrument: create(:instrument))

      expect(evaluation.token).not_to be_nil
    end
  end
end
