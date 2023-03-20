class TeamsSelection < ApplicationRecord
  belongs_to :games_enrollment
  belongs_to :round
  belongs_to :team
end
