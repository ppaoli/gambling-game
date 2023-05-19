class GameSetupController < ApplicationController
  # include CompetitionHelper
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
      @game.update(deadline: @game.deadline)



      # CompetitionHelper.create_game_rounds_for_new_game(@game)
      # Update the current_round_number
      @game.update(current_round_number: 1)
      redirect_to game_setup_index_path
    else
      render :new
    end
  end


  def show
    @game = Game.find(params[:id])
    @competition = @game.competition
    round = @competition.closest_upcoming_round
    @fixtures = round.closest_fixture
    @enrollments = current_user.games_enrollments.where(game_id: @game.id)
    @game_round = GameRound.find_by(game: @game, round: round)
  end



  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
    redirect_to game_setup_index_path
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to game_setup_index_path
  end

  private

  def game_params
    params.require(:game).permit(:title, :deadline, :stake, :is_public, :competition_id)
  end
end
