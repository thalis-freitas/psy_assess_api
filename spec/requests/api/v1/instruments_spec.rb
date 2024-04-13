require 'rails_helper'

RSpec.describe 'Api::V1::Instruments', type: :request do
  context 'POST /api/v1/instrument' do
    it 'creates a new instrument' do
      def build_options
        4.times.map do |index|
          {
            text: "Option #{index + 1}",
            score_value: [3, 2, 1, 0][index]
          }
        end
      end

      instrument_attributes = attributes_for(:instrument).merge(
        {
          questions_attributes: 5.times.map do
            {
              text: Faker::Lorem.question,
              options_attributes: build_options
            }
          end
        }
      )

      post '/api/v1/instruments', params: { instrument: instrument_attributes },
                                  headers: psychologist_token

      expect(response).to have_http_status(:created)
      expect(json[:name]).to eq(instrument_attributes[:name])
      expect(Instrument.last.questions.count).to eq(5)
      expect(Instrument.last.questions.first.options.count).to eq(4)
    end
  end
end
