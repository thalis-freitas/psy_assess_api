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

  def set_evaluated
    @evaluated = User.find(params[:id])

    return render status: :not_found if !@evaluated.evaluated?
  end
end
