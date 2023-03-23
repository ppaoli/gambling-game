class GamesController < ApplicationController
  before_action :set_game, only: [:show]

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
