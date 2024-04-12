class User < ApplicationRecord
  has_secure_password

  enum role: { evaluated: 0, psychologist: 5 }

  validates :name, :cpf, :email, :birth_date, presence: true, if: :evaluated?
  validates :cpf, :email, uniqueness: { if: :evaluated? }

  before_validation :update_default_password, if: :evaluated?

  def birth_date
    super().strftime('%d/%m/%Y') if super().present?
  end

  private

  def update_default_password
    self.password ||= cpf
  end
end
