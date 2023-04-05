class GamesEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :teams_selections
  enum status: { eliminated: 0, active: 1, winner: 2 }
  # validates :num_entries, inclusion: { in: 1..2 }
  before_create :set_default_status
  validates :user_id, uniqueness: { scope: %i[game_id entry_id] }



  def has_won?
    # Get all teams the user has previously selected in previous rounds
    previous_teams = self.games_enrollments.where.not(id: self.id).pluck(:selected_team_id)

    # Get the team the user selected for the current round
    current_team = self.teams_selections.last.team_id

    # Check if the current team has already been selected in previous rounds
    if previous_teams.include?(current_team)
      return false
    end

    # Get the fixtures for the current round
    fixtures = self.game.competition.fixtures.where(match_day: self.round_number)

    # Check if the user's selected team has won the fixture
    selected_team_won = fixtures.any? do |fixture|
        fixture.home_team_id == current_team && fixture.home_team_score > fixture.away_team_score ||
        fixture.away_team_id == current_team && fixture.away_team_score > fixture.home_team_score
    end

    return selected_team_won
  end


    # # Calculate the remaining participants
    # remaining_participants = GamesEnrollment.where(game: game, status: 'active').count

    # # Check if the user is part of the remaining participants
    # if remaining_participants <= (0.01 * participants)
    #   # If less than 1% of participants are remaining, they share 10% of the pot
    #   user_share = (0.1 * game.total_pot) / remaining_participants
    #   update(won_share: user_share, status: :winner)
    #   return true
    # elsif remaining_participants == 1
    #   # If only one user is remaining, they win 70% of the pot
    #   user_share = 0.7 * game.total_pot
    #   update(won_share: user_share, status: :winner)
    #   return true
    # else
    #   # If the user is still in the game but has not won yet, return false
    #   return false
    # end


  private

  def set_default_status
    Rails.logger.debug("Setting default status for GamesEnrollment")
    self.status ||= :active
  end
end
