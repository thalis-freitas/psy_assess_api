class Answer < ApplicationRecord
  belongs_to :evaluation
  belongs_to :question
  belongs_to :option

  after_create :finalize_evaluation

  validate :all_questions_must_be_filled

  private

  def all_questions_must_be_filled
    errors.add(:base, :all_questions_must_be_filled) if option_id.blank?
  end

  def finalize_evaluation
    return unless evaluation.answers.count == evaluation.instrument.questions.count

    total_score = evaluation.answers.sum(:score)
    evaluation.update!(status: 'finished', score: total_score)
  end
end
