class Game < ApplicationRecord
  belongs_to :competition
  has_many :rounds
  validates :stake, presence: true, numericality: { greater_than_or_equal_to: 10 }
  has_many :games_enrollments
  validates :is_public, inclusion: { in: [true, false] }
end
