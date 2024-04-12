class Api::V1::EvaluatedController < Api::V1::ApiController
  before_action :authorize
  before_action :set_evaluated, only: %i[show]

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
      render json: { errors: @evaluated.errors.full_messages },
             status: :unprocessable_entity
    end
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
