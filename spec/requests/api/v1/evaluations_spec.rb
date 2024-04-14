require 'rails_helper'

describe 'Api::V1::EvaluationsController', type: :request do
  describe 'POST /api/v1/evaluations' do
    it 'creates an evaluation for an evaluated user with a given instrument' do
      evaluated = create(:user)
      instrument = create(:instrument)

      post '/api/v1/evaluations', headers: psychologist_token,
                                  params: { evaluated_id: evaluated.id,
                                            instrument_id: instrument.id }

      expect(response).to have_http_status(:ok)
      expect(Evaluation.count).to eq(1)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(json[:message]).to eq('E-mail enviado com sucesso')
    end

    it 'when faile does not create an evaluation' do
      post '/api/v1/evaluations', headers: psychologist_token,
                                  params: { evaluated_id: nil,
                                            instrument_id: nil }

      expect(response).to have_http_status(:not_found)
      expect(Evaluation.count).to eq(0)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end

    it 'prevents duplicate instrument assignment to the same evaluated' do
      evaluated = create(:user)
      instrument = create(:instrument)
      create(:evaluation, evaluated:, instrument:)

      post '/api/v1/evaluations', headers: psychologist_token,
                                  params: { evaluated_id: evaluated.id,
                                            instrument_id: instrument.id }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:instrument_id])
        .to include('Este instrumento já foi aplicado a este avaliado')
    end
  end
end
