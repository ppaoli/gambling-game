class Game < ApplicationRecord
  belongs_to :competition
  has_many :rounds
  has_many :games_enrollments
end
