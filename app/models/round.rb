class Round < ApplicationRecord
  belongs_to :game
  has_many :teams_selections
end
