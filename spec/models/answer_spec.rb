require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it 'belongs to evaluation' do
      answer = Answer.new
      expect(answer).to respond_to(:evaluation)
    end

    it 'belongs to question' do
      answer = Answer.new
      expect(answer).to respond_to(:question)
    end

    it 'belongs to option' do
      answer = Answer.new
      expect(answer).to respond_to(:option)
    end
  end

  describe '#valid' do
    context 'when option_id is blank' do
      it 'adds a custom error message' do
        evaluation = create(:evaluation)
        question = create(:question)
        answer = Answer.new(evaluation:, question:, option_id: nil)

        answer.valid?

        expect(answer.errors[:base]).to include('Todas as questões devem ser respondidas')
      end
    end
  end
end
