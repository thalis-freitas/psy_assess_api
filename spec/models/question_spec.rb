require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it 'belongs to an instrument' do
      association = Question.reflect_on_association(:instrument)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many options' do
      association = Question.reflect_on_association(:options)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroys options when question is destroyed' do
      question = create(:question)
      create(:option, question:)

      question.destroy

      expect(Option.count).to eq(0)
    end
  end
end
