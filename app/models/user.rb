class User < ApplicationRecord
  has_secure_password

  enum role: { evaluated: 0, psychologist: 5 }

  validates :name, :cpf, :email, :birth_date, presence: { if: :evaluated? }
  validates :cpf, :email, uniqueness: { if: :evaluated? }, allow_blank: true
  validate :validate_birth_date_cannot_be_future

  before_validation :update_default_password, if: :evaluated?

  def birth_date
    super().strftime('%d/%m/%Y') if super().present?
  end

  private

  def update_default_password
    self.password ||= cpf.presence || 'password_default'
  end

  def validate_birth_date_cannot_be_future
    return if birth_date.blank?

    parsed_date = Date.parse(birth_date)
    errors.add(:birth_date, 'não pode ser futura') if parsed_date > Time.zone.today
  end
end
