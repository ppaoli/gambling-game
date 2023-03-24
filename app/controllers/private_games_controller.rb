class PrivateGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.is_public = false
    @game.user = current_user

    # Fetch fixtures for the selected competition, season, and round
    competition_id = 8 # Example: Premier League
    season_id = 19734 # Example: 2022/2023 season
    round_id = 29 # Example: Matchday 29
    football_data_service = FootballDataService.new
    response = football_data_service.get_fixtures(competition_id, season_id, round_id)

    if response['data'].any?
      if @game.save
        redirect_to private_game_path(@game), notice: 'Private game successfully created!'
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_private_game_path, alert: 'There are no upcoming matches for the selected competition and matchday.'
    end
  end



  def show
  end

  def edit
  end

  def fetch_and_create_competition(competition_id)
    competition = Competition.find_by(id: competition_id)

    unless competition
      football_data_service = FootballDataService.new
      competition_data = football_data_service.get_competition(competition_id)

      competition = Competition.create!(
        id: competition_data['id'],
        name: competition_data['name'],
        # Add any other fields you need for your Competition model
      )
    end

    competition
  end


  def update
    if @game.update(game_params)
      redirect_to private_game_path(@game), notice: 'Private game successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy
    redirect_to private_games_path, notice: 'Private game successfully deleted!'
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end


  def game_params
    params.require(:game).permit(:competition_id, :stake, :start_date, :deadline, :num_players, :title, :user_id)
  end
end
