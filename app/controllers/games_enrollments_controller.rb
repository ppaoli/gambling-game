class GamesEnrollmentsController < ApplicationController
  include EnrollmentHelper

  before_action :authenticate_user!
  before_action :set_game
  before_action :set_enrollment, only: [:edit, :update, :destroy]

  def new
    existing_enrollment = @game.games_enrollments.find_by(user_id: current_user.id)
    if existing_enrollment
      flash[:error] = "You have already enrolled in this game."
      redirect_to game_setup_path
    else
      @enrollment = GamesEnrollment.new
    end
  end

  def create
    user_id = current_user.id
    entries = params[:entries].to_i
    existing_enrollments = @game.games_enrollments.where(user_id: user_id, game_id: @game.id)

    if existing_enrollments.present?
      # Scenarios 3 and 4
      update_existing_enrollment(existing_enrollments)
    else
      # Scenarios 1 and 2
      enroll_user(user_id, entries)
    end

    redirect_to game_setup_path(@game)
  end

  def edit
  end

  def update
    if @enrollment.user_id != current_user.id
      flash[:error] = "You can only update your own enrollment."
      redirect_to game_setup_path
      return
    end
    user_id = current_user.id

    # Scenario 5: User decides to remove all his entries and exit the game before the deadline has passed
    if @game.deadline > DateTime.now && params[:entries].to_i == 0
      @enrollment.destroy
      flash[:notice] = "You have successfully exited the game."
      redirect_to game_setup_path
      return
    end

    # Scenarios 3 and 4
    update_existing_enrollment(@enrollment)
    redirect_to game_setup_path
  end

  def destroy
    @enrollment.destroy
    flash[:notice] = "You have been removed from the game."
    redirect_to game_setup_path
  end

  private

  def set_game
    @game = Game.find(params[:game_setup_id])
  end

  def set_enrollment
    @enrollment = GamesEnrollment.find(params[:id])
    @game = @enrollment.game
  end

  def enrollment_params
    params.require(:game).permit(:entries)
  end

end
