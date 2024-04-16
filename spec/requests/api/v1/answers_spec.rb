require 'rails_helper'

describe 'Api::V1::EvaluationsController', type: :request do
  context 'POST /api/v1/evaluations/:evaluation_id/answers' do
    it 'creates an answer for the evaluation' do
      user = create(:user)
      instrument = create(:instrument)
      evaluation = create(:evaluation, instrument:, evaluated: user)
      question = create(:question, instrument:)
      option = create(:option, question:)

      post "/api/v1/evaluations/#{evaluation.id}/answers",
           params: { answers: [{ question_id: question.id, option_id: option.id }] }

      expect(response).to have_http_status(:created)
      expect(evaluation.reload.answers.count).to eq(1)
      expect(evaluation.status).to eq('finished')
      expect(evaluation.score).to eq(option.score_value)
    end

    it 'returns an error when the answer data is invalid' do
      user = create(:user)
      instrument = create(:instrument)
      evaluation = create(:evaluation, instrument:, evaluated: user)
      option = create(:option)

      post "/api/v1/evaluations/#{evaluation.id}/answers",
           params: { answers: [{ question_id: nil, option_id: option.id }] }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
