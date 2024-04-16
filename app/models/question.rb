class Question < ApplicationRecord
  belongs_to :instrument

  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true
end
