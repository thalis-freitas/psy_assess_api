class Api::V1::EvaluatedController < Api::V1::ApiController
  before_action :authorize
  before_action :set_evaluated, only: %i[show update instruments]

  def index
    @evaluated = User.where(role: :evaluated)
    render json: { evaluated: @evaluated }, status: :ok
  end

  def show
    render json: { evaluated: @evaluated }, status: :ok
  end

  def create
    @evaluated = User.build(evaluated_params)

    if @evaluated.save
      render json: @evaluated, status: :created
    else
      render json: { errors: @evaluated.errors },
             status: :unprocessable_entity
    end
  end

  def update
    if @evaluated.update(evaluated_params)
      render json: @evaluated, status: :ok
    else
      render json: { errors: @evaluated.errors },
             status: :unprocessable_entity
    end
  end

  def instruments
    instruments = @evaluated.evaluations.includes(:instrument).map do |evaluation|
      { id: evaluation.id, evaluated_id: evaluation.evaluated_id,
        instrument_id: evaluation.instrument_id, status: evaluation.status,
        name: evaluation.instrument.name }
    end

    render json: instruments, status: :ok
  end

  private

  def set_evaluated
    @evaluated = User.find(params[:id])

    render status: :not_found unless @evaluated.evaluated?
  end

  def evaluated_params
    params.require(:evaluated).permit(:name, :cpf, :email, :birth_date)
  end
end
