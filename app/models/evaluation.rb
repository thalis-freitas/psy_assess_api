class Evaluation < ApplicationRecord
  belongs_to :evaluated, class_name: 'User'
  belongs_to :instrument

  before_create :generate_unique_token

  enum status: { pending: 0, sent: 3, finished: 5 }

  validate :evaluated_must_be_valid_role
  validates :token, uniqueness: true
  validates :instrument_id, uniqueness: { scope: :evaluated_id,
                                          message: I18n.t('errors.instrument_already_applied') },
                            on: :create

  private

  def evaluated_must_be_valid_role
    return if evaluated&.evaluated?

    errors.add(:evaluated, I18n.t('errors.must_be_evaluated_role'))
  end

  def generate_unique_token
    self.token = SecureRandom.hex(10)
  end
end
