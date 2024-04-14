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
end
