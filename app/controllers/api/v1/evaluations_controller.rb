class Api::V1::EvaluationsController < Api::V1::ApiController
  before_action :authorize

  def create
    evaluated = User.find(evaluation_params[:evaluated_id])
    instrument = Instrument.find(evaluation_params[:instrument_id])
    @evaluation = Evaluation.new(evaluated:, instrument:)

    if @evaluation.save
      send_instrument
    else
      render json: evaluation.errors, status: :unprocessable_entity
    end
  end

  def send_instrument
    @evaluation.update!(status: :sent)

    EvaluationMailer.send_instrument(@evaluation).deliver_now

    render json: { message: 'Email enviado com sucesso.' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def evaluation_params
    params.permit(:evaluated_id, :instrument_id)
  end
end
