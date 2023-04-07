class TeamsSelectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game
  before_action :set_enrollment
  before_action :check_enrollment_status
  before_action :set_selection, only: [:edit, :update, :destroy]
  before_action :check_selection_round, only: [:edit, :update, :destroy]
  before_action :set_round

  def new
    @selections = @enrollment.teams_selections.includes(:round, :team)
    @round_selections = @selections.select { |s| s.round.number == @round.number }
    @max_selections = @enrollment.max_selections_for_round(@round)
    @teams = @game.teams
  end

  def create
    @selections = @enrollment.teams_selections.includes(:round, :team)
    @round_selections = @selections.select { |s| s.round.number == @round.number }
    @max_selections = @enrollment.max_selections_for_round(@round)
    @teams = @game.teams

    if Time.current > @round.deadline
      flash[:error] = "The deadline has passed, you cannot make team selections for this round."
      redirect_to game_enrollment_teams_selections_path(@game, @enrollment)
      return
    end

    # Iterate through the selections params and create/update the corresponding TeamsSelection objects
    selections_params.each do |round_id, team_id|
      next unless @rounds.find_by(id: round_id)

      selection = @enrollment.teams_selections.find_or_initialize_by(round_id: round_id)
      selection.team_id = team_id
      selection.save
    end

    flash[:notice] = "Your team selections have been updated successfully."
    redirect_to game_enrollment_teams_selections_path(@game, @enrollment)
  end

  def edit
    @round = @selection.round
    @teams = @game.teams
  end

  def update
    @teams = @game.teams

    if Time.current > @selection.round.deadline
      flash[:error] = "The deadline has passed, you cannot change your team selection for this round."
      redirect_to game_enrollment_teams_selections_path(@game, @enrollment)
      return
    end

    if @selection.update(selection_params)
      flash[:notice] = "Your team selection has been updated successfully."
      redirect_to game_enrollment_teams_selections_path(@game, @enrollment)
    else
      @round = @selection.round
      render :edit
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_enrollment
    @enrollment = @game.games_enrollments.find(params[:games_enrollment_id])

  end

  def set_selection
    @selection = TeamsSelection.find(params[:id])
    @enrollment = @selection.games_enrollment
    @game = @enrollment.game
  end

  def check_enrollment_status
    if @enrollment.eliminated?
      flash[:error] = "You cannot make team selections for an eliminated entry."
      redirect_to game_path(@game)
    end
  end

  def check_selection_round
    if @selection.round.start_time < Time.current
      flash[:error] = "You cannot change your team selection for a round that has already started."
      redirect_to game_enrollment_teams_selections_path(@game, @enrollment)
    end
  end

  def selections_params
    params.require(:teams_selections).permit!
  end

  def selection_params
    params.require(:teams_selection).permit(:team_id)
  end

  def check_user_eligibility_for_selection
    enrollments_count = @enrollment.teams_selections.count
    max_enrollments = @enrollment.max_enrollments

    if enrollments_count >= max_enrollments
      flash[:error] = "You cannot make any more team selections."
      redirect_to game_enrollment_teams_selections_path(@game, @enrollment)
    end
  end

  def check_selection_deadline
    if @selection.round.deadline.past?
      flash[:error] = "The deadline for making team selections has passed."
      redirect_to game_enrollment_teams_selections_path(@game, @enrollment)
    end
  end

  def set_upcoming_round_for_selection
    @round = @game.rounds.where("start_time > ?", Time.current).order(start_time: :asc).first
    if @round.nil?
      flash[:error] = "There are no upcoming rounds for this game."
      redirect_to game_path(@game)
    end
  end

  def check_team_selection_count
    enrollments_count = @enrollment.teams_selections.count
    max_enrollments = @enrollment.max_enrollments

    if enrollments_count == 1 && max_enrollments == 2
      flash[:error] = "You can only make 1 team selection for this game."
      redirect_to game_enrollment_teams_selections_path(@game, @enrollment)
    end
  end

  def set_round
    @round = @game.rounds.find_by(round_number: params[:round_number])
  end
end
