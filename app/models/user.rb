class User < ApplicationRecord
  enum role: { evaluated: 0, psychologist: 5 }
end
