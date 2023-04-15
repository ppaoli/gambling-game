class GamesController < ApplicationController
  before_action :set_game, only: [:show]
  before_action :competitions_all, only: [:index, :new_public_game, :create_public_game]

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
      @enrollment = current_user.games_enrollments.find_by(game_id: @game.id)
      @existing_enrollments = current_user.games_enrollments.where(game_id: @game.id)
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

    # Set the `deadline` value in the `@game` instance
    @game.deadline = sports_monk_service.get_deadline(fixtures)
    puts "DEADLINE OF NEW GAME IS #{@game.deadline} "

    respond_to do |format|
      if @game.save
        # Create the first round for the game
        sport_monk_round_id = sports_monk_service.get_round_id(fixtures)
        round = @game.rounds.create(sport_monk_round_id: sport_monk_round_id)

        # If the round fails to create, delete the game and return an error message
        unless round.persisted?
          @game.destroy
          format.html { redirect_to new_public_game_path, alert: 'Error creating game. Please try again.' }
          format.json { render json: { errors: round.errors.full_messages }, status: :unprocessable_entity }
          return
        end

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

  def update_rounds
    game = Game.find(params[:id])
    sports_monk_service = SportsMonkService.new
    competition_id = game.competition.sport_monk_competition_id
    closest_upcoming_round_fixtures, sport_monk_round_id, deadline = sports_monk_service.get_closest_upcoming_round_fixtures(competition_id)

    # Find the next round number
    next_round_number = game.current_round_number + 1

    # Check if the current round is finished
    if closest_upcoming_round_fixtures.present? && closest_upcoming_round_fixtures['finished'] == true
      # Update the game's current round number
      game.update(current_round_number: next_round_number, deadline: deadline)
      # Create the next round for the game
      round = game.rounds.create(sport_monk_round_id: sport_monk_round_id)
      # If the round fails to create, delete the game and return an error message
      unless round.persisted?
        game.destroy
        redirect_to games_path, alert: 'Error creating round. Please try again.'
        return
      end
    end

    redirect_to game_path(game)
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
