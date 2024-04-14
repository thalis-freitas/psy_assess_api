class Api::V1::EvaluationsController < Api::V1::ApiController
  before_action :authorize

  def create
    evaluated = User.find(params[:evaluated_id])

    instrument = Instrument.find(params[:instrument_id])

    evaluation = Evaluation.new(evaluated:, instrument:)

    if evaluation.save
      render json: evaluation, status: :created
    else
      render json: evaluation.errors, status: :unprocessable_entity
    end
  end
end
