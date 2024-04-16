class Api::V1::AnswersController < Api::V1::ApiController
  before_action :set_evaluation

  def create
    answers_params.each do |answer_param|
      @evaluation.answers.create!(answer_param)
    end

    render json: { answers: @evaluation.answers }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  private

  def set_evaluation
    @evaluation = Evaluation.find(params[:evaluation_id])
  end

  def answers_params
    params.require(:answers).map do |p|
      p.permit(:question_id, :option_id)
    end
  end
end
