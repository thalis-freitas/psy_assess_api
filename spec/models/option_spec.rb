require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'associations' do
    it 'belongs to a question' do
      option = Option.new
      expect(option).to respond_to(:question)
    end

    it 'has many answers' do
      option = Option.new
      expect(option).to respond_to(:answers)
    end
  end
end
