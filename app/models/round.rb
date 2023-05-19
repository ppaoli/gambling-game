class Round < ApplicationRecord
  belongs_to :competition
  has_many :teams_selections
  has_many :fixtures
  has_many :game_rounds
  has_many :games, through: :game_rounds


  def closest_fixture
    fixtures.order(:starting_at)
  end
end
