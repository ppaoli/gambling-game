class GameRound < ApplicationRecord
  belongs_to :game
  belongs_to :round
end
