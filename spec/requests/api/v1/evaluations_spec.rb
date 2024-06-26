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

      get "/api/v1/confirm/#{evaluation.token}"

      expect(response).to have_http_status(:ok)
      expect(json[:evaluation][:id]).to eq(evaluation.id)
      expect(json[:evaluated][:name]).to eq(evaluated.name)
      expect(json[:evaluated][:cpf]).to eq(evaluated.cpf)
      expect(json[:evaluated][:email]).to eq(evaluated.email)
      expect(json[:evaluated][:birth_date]).to eq(evaluated.birth_date.to_s)
    end

    it 'returns an error when token is invalid' do
      get '/api/v1/confirm/invalid_token'

      expect(response).to have_http_status(:not_found)
      expect(json[:error]).to eq('Token inválido')
    end
  end

  context 'POST /api/v1/evaluations/:id/confirm_data' do
    it 'updates the evaluated data' do
      evaluated = create(:user, role: :evaluated)
      instrument = create(:instrument)
      evaluation = create(:evaluation, evaluated:, instrument:)

      updated_data = { name: 'Updated Name', birth_date: '2001-01-01' }

      post "/api/v1/evaluations/#{evaluation.id}/confirm_data",
           params: { evaluated: updated_data }

      expect(response).to have_http_status(:ok)
      expect(evaluated.reload.name).to eq('Updated Name')
    end

    it 'returns errors if the update fails' do
      evaluated = create(:user, role: :evaluated)
      instrument = create(:instrument)
      evaluation = create(:evaluation, evaluated:, instrument:)

      invalid_data = { name: '', cpf: '', email: '', birth_date: '' }
      post "/api/v1/evaluations/#{evaluation.id}/confirm_data",
           params: { evaluated: invalid_data }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:errors]).to be_present
    end
  end

  context 'GET /api/v1/evaluations/:id/start' do
    it 'starts an evaluation successfully' do
      evaluated = create(:user, role: :evaluated)
      instrument = create(:instrument, :with_questions)
      evaluation = create(:evaluation, evaluated:, instrument:)

      get "/api/v1/evaluations/#{evaluation.id}/start"

      expect(response).to have_http_status(:ok)
      expect(evaluation.reload.status).to eq('in_progress')
      expect(json[:evaluation][:instrument]).to be_present

      expect(json[:evaluation][:instrument][:questions].first[:options])
        .not_to be_empty
    end

    it 'does not change to in_progress when evaluation status is finished' do
      create(:user, role: :evaluated)
      create(:instrument, :with_questions)
      evaluation = create(:evaluation, :finished)

      get "/api/v1/evaluations/#{evaluation.id}/start"

      expect(response).to have_http_status(:ok)
      expect(evaluation.reload.status).not_to eq('in_progress')
      expect(json[:evaluation][:instrument]).not_to be_present
    end
  end
end
