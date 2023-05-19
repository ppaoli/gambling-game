module CompetitionHelper
  class << self

    # ADD these methods in the rounds model
    def closest_upcoming_round(competition)
      competition.rounds.where('starting_at > ?', Time.zone.now).order(:starting_at).first
    end

    # Move whole method to the game model in a method called closest round
    def calc_deadline(game)
      closest_round = closest_upcoming_round(game.competition)
      closest_upcoming_fixture = closest_round.fixtures.order(:starting_at).first
      (closest_upcoming_fixture.starting_at - 2.hours).in_time_zone(Time.zone)
    end

    # Scope
    def fixtures(round)
      round.fixtures.includes(:home_team, :away_team)
    end



    def create_game_rounds_for_new_game(game)
      competition = game.competition
      upcoming_rounds = competition.rounds.where('starting_at >= ?', Time.zone.now).order(:starting_at)
      upcoming_rounds.each_with_index do |round, index|
        GameRound.create(game: game, round: round, game_round_number: index + 1)
      end
    end

    def check_round_finished_and_update_games(round)
      if round.finished
        games_related_to_round = Game.joins(:game_rounds).where(game_rounds: { round_id: round.id })
        games_related_to_round.each do |game|
          increment_current_round_number(game)
        end
      end
    end

    def increment_current_round_number(game)
      current_round_number = game.current_round_number
      next_round_number = current_round_number + 1
      if next_round_number <= game.game_rounds.count
        game.update(current_round_number: next_round_number)
      end
    end
  end
end




    # # Getting remaining fixtures by round
    # def parse_remaining_fixtures_by_round(rounds)
    #   remaining_fixtures = {}

    #   rounds.each do |round|
    #     round_name = "round_#{round['name']}"
    #     round_finished = round['finished']

    #     next if round_finished

    #     fixtures = parsed_fixtures(round['fixtures']).sort_by { |fixture| fixture['starting_at'] }
    #     upcoming_fixtures = []

    #     fixtures.each do |fixture|
    #       starting_at_utc = fixture['starting_at']
    #       current_time = Time.now.utc
    #       # Skip this fixture if it's in the past
    #       next if Time.parse(starting_at_utc) <= current_time

    #       teams = extract_teams_info(fixture)
    #       fixture_str = "#{teams[:home_team]} vs #{teams[:away_team]} #{DateTime.parse(starting_at_utc).strftime('%-d %b %Y %H:%M')}"
    #       upcoming_fixtures << fixture_str
    #     end

    #     remaining_fixtures[round_name] = upcoming_fixtures unless upcoming_fixtures.empty?
    #   end

    #   remaining_fixtures = remaining_fixtures.sort_by { |round_name, fixtures| DateTime.parse(fixtures.first.split(' ')[-4..-2].join(' ')) }.to_h
    # end

    # def next_round_fixtures(rounds)
    #   remaining_fixtures = parse_remaining_fixtures_by_round(rounds)
    #   remaining_fixtures.first
    # end
 # def fetch_fixtures(competition_id, round_name = nil)
  #   rounds = get_rounds(competition_id)
  #   fixtures = []

  #   if round_name
  #     # Find the round with the given name
  #     target_round = find_target_round(rounds, round_name)

  #     # If the round was found, extract its fixtures
  #     if target_round
  #       fixtures = target_round['fixtures']
  #     end
  #   else
  #     rounds.each do |round|
  #       fixtures += round['fixtures']
  #     end
  #   end

  #   # Remove unwanted key-value pairs from each fixture
  #   parsed_fixtures = parsed_fixtures(fixtures)

  #     # Group fixtures by round_id
  #   fixtures_by_round = parsed_fixtures.group_by { |fixture| fixture['round_id'] }

  #   fixtures_by_round
  # end

  # def all_participants(competition_id)
  #   fixtures = all_fixtures(competition_id)
  #   participants = fixtures.map { |fixture| fixture['participants'] }.flatten
  #   parsed_participants(participants)
  # end


  # def fetch_first_round_data(competition_id)
  #   rounds_data = get_rounds(competition_id)
  #   rounds_data[0]
  # end

  # def fetch_team_ids(competition_id)
  #   first_round = fetch_first_round_data(competition_id)
  #   parse_team_ids_from_first_round(first_round)
  # end

  # def all_rounds_details(competition_id)
  #   rounds = get_rounds(competition_id)
  #   parse_rounds_details(rounds)
  # end

  # def round_team_results(competition_id, target_round_name)
  #   rounds = get_rounds(competition_id)
  #   target_round = find_target_round(rounds, target_round_name)

  #   return puts "Round #{target_round_name} not found" unless target_round

  #   puts "Round #{target_round_name}"
  #   parse_team_results_from_round(target_round)
  # end

  # def fetch_round_fixtures(competition_id, round_id)
  #   rounds = get_rounds(competition_id)
  #   specific_round = rounds.find { |round| round['id'] == round_id }
  #   specific_round['fixtures']
  # end

  # def team_has_won?(competition_id, sport_monk_round_id)
  #   fixtures = fetch_round_fixtures(competition_id, sport_monk_round_id)
  #   parse_team_has_won?(fixtures)
  # end


  # def fetch_round_fixtures2(competition_id, round_id)
  #   rounds = get_rounds(competition_id)
  #   specific_round = rounds.find { |round| round['id'] == round_id }
  #   parse_fixtures_by_given_round(specific_round['fixtures'])
  # end

  # def remaining_fixtures(competition_id)
  #   rounds = get_rounds(competition_id)
  #   parse_remaining_fixtures_by_round(rounds)
  # end

  # def next_round(competition_id)
  #   rounds = get_rounds(competition_id)
  #   next_round_fixtures(rounds)
  # end


  # def convert_utc_to_bst(utc_time_string)
  #   utc_time = Time.parse(utc_time_string)
  #   bst_time = utc_time.getlocal('+03:00')
  #   bst_time.strftime('%Y-%m-%d %H:%M:%S')
  # end

  # def fixtures_results(competition_id, target_round)
  #   rounds = get_rounds(competition_id)
  #   target_round_data = find_target_round(rounds, target_round)
  #   parse_results_by_given_round(target_round_data)
  # end

  # def get_closest_upcoming_round_fixtures(competition_id)
  #   response = HTTParty.get("#{self.class.base_uri}/schedules/seasons/#{competition_id}",
  #     query: {'api_token' => @api_token },
  #     headers: { 'Accept' => 'application/json' })

  #   data = JSON.parse(response.body)['data']
  #   closest_upcoming_round = nil
  #   min_time_difference = Float::INFINITY

  #   data.each do |element|
  #     element['rounds'].each do |round|
  #       round_starting_at = DateTime.parse(round['starting_at'])
  #       time_difference = (round_starting_at - DateTime.now).to_f
  #       if time_difference > 0 && time_difference < min_time_difference
  #         min_time_difference = time_difference
  #         closest_upcoming_round = round
  #       end
  #     end
  #   end
  #   # puts "Closest upcoming round: #{closest_upcoming_round}"

  #   closest_upcoming_fixtures = closest_upcoming_round['fixtures']

  #   # Sort fixtures by starting time
  #   closest_upcoming_fixtures.sort_by! { |fixture| fixture['starting_at'] }

  #   # Display fixtures in chronological order
  #   round_fixtures = closest_upcoming_fixtures.each do |fixture|
  #     puts "Fixture: #{fixture['name']} (#{fixture['starting_at']})"
  #   end

  #   return round_fixtures
  # end

  # def get_deadline(closest_upcoming_fixtures)
  #   deadline = DateTime.parse(closest_upcoming_fixtures.first['starting_at']) - Rational(2, 24)
  #   deadline = deadline.strftime('%Y-%m-%d %H:%M:%S')
  #   puts "Deadline: #{deadline}"
  # end
