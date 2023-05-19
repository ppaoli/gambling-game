class TeamsSelection < ApplicationRecord
  belongs_to :games_enrollment
  belongs_to :team
  belongs_to :round
end
