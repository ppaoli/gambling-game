class GameSetupController < ApplicationController
  include CompetitionHelper
  before_action :authenticate_admin!

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
    @competitions = Competition.all
  end

  def create
    @game = Game.new(game_params)
    @game.is_public = true
    @game.user_id = current_user.id
    if @game.save
      @game.update(deadline: CompetitionHelper.deadline(@game))
      redirect_to game_setup_path(@game)
    else
      render :new
    end
  end

  def show
    @game = Game.find(params[:id])
    competition = @game.competition
    round = CompetitionHelper.closest_upcoming_round(competition)
    @fixtures = CompetitionHelper.fixtures(round)
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
    redirect_to game_path(@game)
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:title, :deadline, :stake, :is_public, :competition_id)
  end
end
