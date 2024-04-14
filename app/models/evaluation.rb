class Evaluation < ApplicationRecord
  belongs_to :evaluated, class_name: 'User', foreign_key: 'evaluated_id'
  belongs_to :instrument

  enum status: { pending: 0, sent: 3, finished: 5 }

  validate :evaluated_must_be_valid_role

  validates :token, uniqueness: true

  private

  def evaluated_must_be_valid_role
    return if evaluated&.evaluated?

    errors.add(:evaluated, I18n.t('errors.must_be_evaluated_role'))
  end
end
