require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'associations' do
    it 'belongs to a question' do
      association = Option.reflect_on_association(:question)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
