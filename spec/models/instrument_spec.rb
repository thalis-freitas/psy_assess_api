require 'rails_helper'

RSpec.describe Instrument, type: :model do
  describe 'associations' do
    it 'should have many questions' do
      instrument = Instrument.new
      expect(instrument).to respond_to(:questions)
    end

    it 'should destroy questions when instrument is destroyed' do
      instrument = create(:instrument)
      create(:question, instrument:)
      expect { instrument.destroy }.to change { Question.count }.by(-1)
    end
  end
end
