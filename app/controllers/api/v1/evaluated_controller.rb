class Api::V1::EvaluatedController < Api::V1::ApiController
  before_action :authorize

  def index
    @evaluated = User.where(role: :evaluated)
    render json: { evaluated: @evaluated }, status: :ok
  end
end
