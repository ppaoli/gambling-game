class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def create
    @game = current_user.games.new(game_params)
    if @game.save
      redirect_to new_game_team_selection_path(@game)
    else
      render :new
    end
  end


  def index
    @games = Game.where(is_public: true)
  end

  def show
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
