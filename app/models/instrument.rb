class Instrument < ApplicationRecord
  has_many :questions, dependent: :destroy

  validates :name, :description, presence: true
  validates :name, uniqueness: true, allow_blank: true

  accepts_nested_attributes_for :questions, allow_destroy: true
end
