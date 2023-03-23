class GamesEnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:new, :create, :index, :destroy]
  before_action :set_enrollment, only: [:destroy]
  before_action :check_deadline, only: [:destroy]

  def index
    @enrollments = @game.games_enrollments.where(user: current_user)
  end

  def new
    @enrollment = @game.games_enrollments.new
  end

  def create
    @enrollment = current_user.games_enrollments.new(enrollment_params)
    @enrollment.game = @game

    if @enrollment.save
      redirect_to game_games_enrollments_path(@game), notice: 'Enrollment created successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @enrollment.destroy
    redirect_to game_games_enrollments_path(@game), notice: 'Enrollment deleted successfully!'
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_enrollment
    @enrollment = @game.games_enrollments.find(params[:id])
  end

  def enrollment_params
    params.require(:games_enrollment).permit(:entry_identifier)
  end

  def deadline_passed?
    @game.deadline < Time.current
  end

  def check_deadline
    if deadline_passed?
      redirect_to game_games_enrollments_path(@game), alert: 'The enrollment deadline has passed. You cannot delete your enrollment.'
    end
  end
end
