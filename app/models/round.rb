class Round < ApplicationRecord
  belongs_to :game, optional: true
  belongs_to :competition
  has_many :teams_selections
  has_many :fixtures
end
