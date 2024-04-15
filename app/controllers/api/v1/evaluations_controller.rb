class Api::V1::EvaluationsController < Api::V1::ApiController
  before_action :authorize, except: %i[confirm confirm_data]
  before_action :set_evaluation, only: %i[show confirm_data]

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
    @evaluation.update!(status: :sent) if EvaluationMailer.send_instrument(@evaluation).deliver_now

    render json: { message: I18n.t('success.email_successfully_sent') },
           status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def confirm
    evaluation = Evaluation.includes(:evaluated).find_by(token: params[:token])
    if evaluation
      evaluated = evaluation.evaluated
      render json: { evaluation:, evaluated: {
        name: evaluated.name, cpf: evaluated.cpf,
        email: evaluated.email, birth_date: evaluated.birth_date
      } }, status: :ok
    else
      render json: { error: I18n.t('errors.invalid_token') }, status: :not_found
    end
  end

  def confirm_data
    evaluated = @evaluation.evaluated
    if evaluated.update(evaluated_params)
      render json: { evaluated:, evaluation: @evaluation },
             status: :ok
    else
      render json: { errors: evaluated.errors },
             status: :unprocessable_entity
    end
  end

  private

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def evaluation_params
    params.permit(:evaluated_id, :instrument_id)
  end

  def evaluated_params
    params.require(:evaluated).permit(:name, :cpf, :email, :birth_date)
  end
end
