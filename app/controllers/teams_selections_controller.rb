class TeamsSelectionsController < ApplicationController
  include CompetitionHelper


  def new
    @enrollment = GamesEnrollment.find(params[:enrollment_id])
    game = @enrollment.game
    competition = game.competition
    round = competition.closest_upcoming_round
    game_round = GameRound.find_by(game: game, round: round)
    @round = game_round.round
    @teams = Team.all
  end


  def create
    enrollment = GamesEnrollment.find(params[:games_enrollment_id])
    game = enrollment.game
    competition = game.competition
    round = competition.closest_upcoming_round
    # Find the GameRound record associated with the current game and round
    game_round = GameRound.find_or_create_by(game: game, round: round) do |gr|
      gr.game_round_number = game.current_round_number
    end

    # Create a new instance of TeamsSelection with the data passed in through the form
    @teams_selection = enrollment.teams_selections.build(teams_selection_params)

    # Set the games_enrollment_id attribute to the ID of the GamesEnrollment record
    # associated with the current user and the specified game and entry
    @teams_selection.games_enrollment_id = enrollment.id

    # Set the round_id attribute to the ID of the Round record associated with the current game and the current round number
    @teams_selection.round_id = game_round.round_id

    # Fetch the name of the selected team
    team = Team.find(@teams_selection.team_id)
    @teams_selection.team_name = team.name

    # Save the TeamsSelection record to the database
    if @teams_selection.save
      redirect_to game_setup_index_path, notice: 'Team selection was successfully created.'
    else
      redirect_to game_setup_path(@game)
    end
  end



  private

  def teams_selection_params
    params.require(:teams_selection).permit(:round_id, :team_name, :team_id)
  end


end
