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

    it 'should have many evaluations' do
      instrument = Instrument.new
      expect(instrument).to respond_to(:evaluations)
    end
  end

  describe '#valid' do
    context 'presence' do
      it 'name field is required' do
        instrument = Instrument.new(name: '')

        instrument.valid?

        expect(instrument.errors.include?(:name)).to be true
        expect(instrument.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'description field is required' do
        instrument = Instrument.new(description: '')

        instrument.valid?

        expect(instrument.errors.include?(:description)).to be true
        expect(instrument.errors[:description]).to include 'não pode ficar em branco'
      end
    end

    context 'uniqueness' do
      it 'should validate uniqueness of name' do
        create(:instrument, name: 'Nome')
        new_instrument = build(:instrument, name: 'Nome')

        new_instrument.valid?

        expect(new_instrument.errors.include?(:name)).to be true
        expect(new_instrument.errors[:name]).to include 'já está em uso'
      end
    end
  end
end
