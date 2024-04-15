require 'rails_helper'

describe 'Api::V1::EvaluationsController', type: :request do
  context 'POST /api/v1/evaluations' do
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
      expect(Evaluation.first.status).to eq('sent')
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

  context 'GET /api/v1/evaluations/:id' do
    it 'returns the correct attributes of a specific evaluations' do
      evaluation = create(:evaluation)

      get "/api/v1/evaluations/#{evaluation.id}", headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json[:evaluation][:status]).to eq(evaluation.status)
      expect(json[:evaluation][:score]).to eq(evaluation.score)

      expect(json[:evaluation].keys)
        .to include(*%i[id instrument evaluated status score description])
    end
  end

  context 'GET /api/v1/confirm/:token' do
    it 'returns evaluation and evaluated details when token is valid' do
      evaluated = create(:user)
      instrument = create(:instrument)
      evaluation = create(:evaluation, evaluated:, instrument:, token: 'valid_token')

      get "/api/v1/confirm/#{evaluation.token}", headers: psychologist_token

      expect(response).to have_http_status(:ok)
      expect(json[:evaluation][:id]).to eq(evaluation.id)
      expect(json[:evaluated][:name]).to eq(evaluated.name)
      expect(json[:evaluated][:cpf]).to eq(evaluated.cpf)
      expect(json[:evaluated][:email]).to eq(evaluated.email)
      expect(json[:evaluated][:birth_date]).to eq(evaluated.birth_date.to_s)
    end

    it 'returns an error when token is invalid' do
      get '/api/v1/confirm/invalid_token', headers: psychologist_token

      expect(response).to have_http_status(:not_found)
      expect(json[:error]).to eq('Token inválido')
    end
  end
end
