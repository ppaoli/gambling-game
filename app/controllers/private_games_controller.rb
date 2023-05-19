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

    if @game.save
      redirect_to private_game_path(@game), notice: 'Private game successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
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
    params.require(:game).permit(:competition_id, :stake, :title, :user_id)
  end
end
