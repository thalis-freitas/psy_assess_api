require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it 'belongs to an instrument' do
      question = Question.new
      expect(question).to respond_to(:instrument)
    end

    it 'has many options' do
      question = Question.new
      expect(question).to respond_to(:options)
    end

    it 'has many answers' do
      question = Question.new
      expect(question).to respond_to(:answers)
    end

    it 'destroys options when question is destroyed' do
      question = create(:question)
      create(:option, question:)

      question.destroy

      expect(Option.count).to eq(0)
    end
  end
end
