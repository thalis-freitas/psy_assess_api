require 'rails_helper'

describe 'Api::V1::EvaluationsController', type: :request do
  describe 'POST /api/v1/evaluations' do
    it 'creates an evaluation for an evaluated user with a given instrument' do
      evaluated = create(:user)
      instrument = create(:instrument)

      post '/api/v1/evaluations', headers: psychologist_token,
                                  params: { evaluated_id: evaluated.id,
                                            instrument_id: instrument.id }

      expect(response).to have_http_status(:created)
      expect(json[:status]).to eq('pending')
    end
  end
end
