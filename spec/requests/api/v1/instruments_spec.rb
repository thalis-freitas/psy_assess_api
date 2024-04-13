require 'rails_helper'

RSpec.describe 'Api::V1::Instruments', type: :request do
  context 'GET /api/v1/instruments' do
    it 'returns a list of all instruments with only name and description' do
      create_list(:instrument, 5)

      get '/api/v1/instruments', headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json.count).to eq(5)
      json.each do |instrument|
        expect(instrument.keys).to contain_exactly(:id, :name, :description)
      end
    end
  end

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

  context 'GET /api/v1/instruments/:id' do
    it 'returns the specified instrument' do
      instrument = create(:instrument, :with_questions)

      get "/api/v1/instruments/#{instrument.id}", headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json[:id]).to eq(instrument.id)
      expect(json[:name]).to eq(instrument.name)
      expect(json[:description]).to eq(instrument.description)
      expect(json[:questions]).to be_an(Array)
      expect(json[:questions].first[:options]).to be_an(Array)
    end

    it 'returns not found if instrument is not found' do
      create(:instrument, :with_questions)

      get '/api/v1/instruments/99999', headers: psychologist_token

      expect(response).to have_http_status(:not_found)
    end
  end
end
