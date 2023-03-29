class TeamSelectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:new, :create, :index, :edit, :update, :destroy]
  before_action :set_team_selection, only: [:update, :destroy]
  before_action :check_deadline, only: [:edit, :update, :destroy]

  def index
    @team_selections = @game.team_selections.where(user: current_user)
  end

# app/controllers/team_selections_controller.rb

def new
  @team_selections = Array.new(current_user.number_of_entries) { @game.team_selections.new }
  sports_monk_service = SportsMonkService.new
  @competitions = sports_monk_service.get_competitions
end



def fetch_fixtures
  competition_id = params[:competition_id]
  sports_monk_service = SportsMonkService.new
  response = sports_monk_service.get_next_fixtures(competition_id)
  @fixtures = response['data']
  @matches = response['data']
  render :new
end




  def create
    authorize @game, :join?
    @team_selections = params[:team_selections].map do |team_selection|
      ts = TeamSelection.new(team_selection.permit(:team_id, :round_id, :entry_identifier))
      ts.user = current_user
      ts.game = @game
      ts
    end

    if @team_selections.all?(&:save)
      # Create new games_enrollment record
      games_enrollment = GamesEnrollment.create(user: current_user, game: @game)
      if games_enrollment.persisted?
        redirect_to game_team_selections_path(@game), notice: 'Team selections successfully created!'
      else
        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team_selection.update(team_selection_params)
    redirect_to game_team_selections_path(@game), notice: 'Team selection successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
      @team_selection.destroy
      redirect_to game_team_selections_path(@game), notice: 'Team selection successfully deleted!'
  end



  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_team_selection
    @team_selection = @game.team_selections.find(params[:id])
  end

  def team_selection_params
    params.require(:team_selection).permit(:team_id, :round_id, :entry_identifier)
  end

  def deadline_passed?
    @game.deadline < Time.current
  end

  def check_deadline
    if deadline_passed?
      redirect_to game_team_selections_path(@game), alert: 'The deadline has passed. You cannot modify your selections.'
    end
  end

end
