class GamesController < ApplicationController
  before_action :set_game, only: [:show]
  before_action :authenticate_admin!, only: [:new_public_game, :create_public_game]

  def index
    @competitions = Competition.all
    @games = Game.where(is_public: true)

    if params[:competition_id].present?
      @games = @games.where(competition_id: params[:competition_id])
    end

    respond_to do |format|
      format.html
      format.js { render partial: 'games_list', locals: { games: @games } }
    end
  end

  def show
  end

  def new_public_game
    @game = Game.new
    sports_monk_service = SportsMonkService.new
    @competitions = sports_monk_service.get_competitions
  end

 

def fetch_fixtures
  @game = Game.find(params[:game_id])
  sports_monk_service = SportsMonkService.new
  season_id = sports_monk_service.get_current_season_id(@game.competition_id)
  @fixtures = sports_monk_service.get_fixtures_by_season_id(season_id)



  def create_public_game
    @game = Game.new(game_params)
    @game.is_public = true
    @game.num_players = nil
    @game.user = current_user

    if @game.save
      sports_monk_service = SportsMonkService.new
      season_id = sports_monk_service.get_current_season_id(@game.competition_id)
      fixtures = sports_monk_service.get_fixtures(season_id)
      # Process the fixtures as needed for your application
      fixtures.each do |fixture|
        Fixture.create(
          competition_id: @game.competition_id,
          home_team_id: fixture['localteam_id'],
          away_team_id: fixture['visitorteam_id'],
          start_time: fixture['time']['starting_at']['date_time']
        )
      end

      redirect_to games_path, notice: 'Public game was successfully created.'
    else
      render :new_public_game
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def authenticate_admin!
    unless current_user && current_user.admin?
      redirect_to root_path, alert: "You don't have permission to perform this action."
    end
  end

  def game_params
    params.require(:game).permit(:competition_id, :stake, :start_date, :deadline, :num_players, :title)
  end
end
