class User < ApplicationRecord
  has_secure_password

  enum role: { evaluated: 0, psychologist: 5 }

  before_validation :update_default_password, if: :evaluated?

  private

  def update_default_password
    self.password ||= cpf
  end
end
