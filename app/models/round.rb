class Round < ApplicationRecord
  belongs_to :game, optional: true
  has_many :teams_selections
  has_many :fixtures
end
