class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user
    if @game.save
      redirect to game_path(@game), notice: 'Game succesfully created, good luck!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:competition_id)
  end

end
