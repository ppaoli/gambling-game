class GamesEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :teams_selections
end
