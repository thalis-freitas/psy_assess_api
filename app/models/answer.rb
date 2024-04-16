class Answer < ApplicationRecord
  belongs_to :evaluation
  belongs_to :question
  belongs_to :option

  validate :all_questions_must_be_filled

  private

  def all_questions_must_be_filled
    errors.add(:base, :all_questions_must_be_filled) if option_id.blank?
  end
end
