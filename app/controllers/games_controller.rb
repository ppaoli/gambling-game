class GamesController < ApplicationController
  before_action :set_game, only: [:show]
  before_action :competitions_all, only: [:index, :new_public_game, :create_public_game]


  # def index
  #   competitions_all
  #   @games = Game.includes(:competition).where(is_public: true)
  #   @games = @games.where(competition_id: params[:competition_id]) if params[:competition_id].present?
  #   @games = @games.where(stake: params[:stake]) if params[:stake].present?
  #   @games = @games.order(deadline: :asc)
  # end

  def index
    competitions_all
    @games = Game.includes(:competition).where(is_public: true)
    if params[:competition_id].present?
      @games = @games.joins(:competition).where('competitions.sport_monk_competition_id': params[:competition_id])
    end
    @games = @games.where(stake: params[:stake]) if params[:stake].present?
    @games = @games.order(deadline: :asc)
  end





  def show
    @game = Game.find(params[:id])
    @fixtures = SportsMonkService.new.get_closest_upcoming_round_fixtures(@game.competition.sport_monk_competition_id)
    # @fixtures = @game.competition.fixtures.order(start_time: :asc)
  end

  def new_public_game
    @game = Game.new
    @competitions = SportsMonkService.new.sportmonk_competitions_ids.map { |comp| [comp[:name], comp[:sport_monk_competition_id]] }
  end


  def create_public_game
    @game = Game.new(game_params)
    @game.is_public = true
    @game.num_players = nil
    @game.user_id = current_user.id
    sports_monk_service = SportsMonkService.new
    competition_details = sports_monk_service.get_sportmonk_competition_details(params[:game][:competition_id])

    sport_monk_sport_id = competition_details[:sport_monk_sport_id]
    sport_monk_country_id = competition_details[:sport_monk_country_id]

    # Create the Sport and Country Models
    # You can use the retrieved Sport and Country IDs to find or create the corresponding Sport and Country models in your application:
    country = Country.find_or_create_by(sport_monk_country_id: sport_monk_country_id)
    sport = Sport.find_or_create_by(sport_monk_sport_id: sport_monk_sport_id)
    competition = Competition.find_or_create_by(sport_monk_competition_id: params[:game][:competition_id])

    competition.update(name: competition_details[:name])

    competition.sport = sport
    competition.country = country

    # Associate the new competition with the game
    @game.competition = competition
    # Save the competition
    unless competition.save
      render :new_public_game
      return
    end

    fixtures = sports_monk_service.get_closest_upcoming_round_fixtures(params[:game][:competition_id])

    # Calculate the deadline as 2 hours before the first fixture in the upcoming round
    first_fixture_start_time = DateTime.parse(fixtures.first['starting_at']) - 2.hours
    @game.deadline = first_fixture_start_time

    respond_to do |format|
      if @game.save
        format.html { redirect_to games_path, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: games_path }
      else
        format.html { render :new_public_game }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    @game = Game.find(params[:id])
    SportsMonkService.new.sportmonk_competitions_ids # This line ensures your competitions table is up-to-date
    @competitions = Competition.all.map { |comp| [comp.name, comp.id] }
  end

  def update
    @game = Game.find(params[:id])

    if @game.update(game_params)
      redirect_to games_path, notice: 'Game was successfully updated.'
    else
      @competitions = SportsMonkService.new.sportmonk_competitions_ids.map { |comp| [comp[:name], comp[:sport_monk_competition_id]] }
      render :edit
    end
  end


  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:competition_id, :start_date, :stake, :deadline, :title)
  end

  def competitions_all
    sports_monk_service = SportsMonkService.new
    @competitions = sports_monk_service.sportmonk_competitions_ids.map do |competition|
      [competition[:name], competition[:sport_monk_competition_id]]
    end
  end
end
