require 'rails_helper'

describe 'Api::V1::EvaluationsController', type: :request do
  context 'POST /api/v1/evaluations/:evaluation_id/answers' do
    it "creates an answer for the evaluation" do
      user = create(:user)
      instrument = create(:instrument)
      evaluation = create(:evaluation, instrument: instrument, evaluated: user)
      question = create(:question, instrument: instrument)
      option = create(:option, question: question)

      post "/api/v1/evaluations/#{evaluation.id}/answers",
           params: { answers: [{ question_id: question.id, option_id: option.id,
                                 score: option.score_value }] }

      expect(response).to have_http_status(:created)
      expect(evaluation.answers.count).to eq(1)
    end

    it "returns an error when the answer data is invalid" do
      user = create(:user)
      instrument = create(:instrument)
      evaluation = create(:evaluation, instrument: instrument, evaluated: user)

      post "/api/v1/evaluations/#{evaluation.id}/answers",
           params: { answers: [{ question_id: nil, option_id: nil, score: nil }] }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
