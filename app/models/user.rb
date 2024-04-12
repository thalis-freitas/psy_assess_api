class User < ApplicationRecord
  has_secure_password

  enum role: { evaluated: 0, psychologist: 5 }
end
