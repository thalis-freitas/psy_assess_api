class Api::V1::EvaluationsController < Api::V1::ApiController
  before_action :authorize
  before_action :set_evaluation, only: :show

  def show
    evaluation = { id: @evaluation.id, evaluated: @evaluation.evaluated.name,
                   instrument: @evaluation.instrument.name,
                   status: @evaluation.status, score: @evaluation.score,
                   description: @evaluation.instrument.description }

    render json: { evaluation: }, status: :ok
  end

  def create
    evaluated = User.find(evaluation_params[:evaluated_id])
    instrument = Instrument.find(evaluation_params[:instrument_id])
    @evaluation = Evaluation.new(evaluated:, instrument:)

    if @evaluation.save
      send_instrument
    else
      render json: @evaluation.errors, status: :unprocessable_entity
    end
  end

  def send_instrument
    @evaluation.update!(status: :sent)

    EvaluationMailer.send_instrument(@evaluation).deliver_now

    render json: { message: I18n.t('success.email_successfully_sent') },
           status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def evaluation_params
    params.permit(:evaluated_id, :instrument_id)
  end
end
