module SportsMonkParser

  def parsed_data(all_rounds)
    rounds = all_rounds
    #Adding competition details
    competition = get_competition_details(rounds)
    all_participants = {}
    fixtures = get_fixtures(rounds, all_participants)
    # Converting participants hash into an array
    participants = convert_participants_hash(all_participants)
    rounds = parsed_rounds(all_rounds)
    {
      competition: competition,
      rounds: rounds,
      fixtures: fixtures,
      participants: participants

    }
  end

  def parsed_rounds(all_rounds)
    all_rounds.map do |round|
      round.except('stage_id', 'fixtures').deep_symbolize_keys
    end
  end

  # Method to get the competition details

  def get_competition_details(rounds)
    # take the fixture straight away instead of rounds
    first_fixture = rounds[0]['fixtures'][0]
    competition_id = first_fixture['season_id']
    competition = sportmonk_competitions_ids.find { |c| c[:sport_monk_competition_id] == competition_id.to_i }
    name = competition[:name] if competition
    sport_monk_country_id = first_fixture['participants'][0]['country_id']
    sport_monk_sport_id = first_fixture['participants'][0]['sport_id']

    { sport_monk_country_id: sport_monk_country_id,
      sport_monk_sport_id: sport_monk_sport_id,
      name: name
    }
  end

  #create competition details in the DB

  def sportmonk_competitions_ids
    [
      { name: 'Premier League', sport_monk_competition_id: 19_734 },
      { name: 'Bundesliga', sport_monk_competition_id: 19_744 },
      { name: 'Ligue 1', sport_monk_competition_id: 19_745 },
      { name: 'Serie A', sport_monk_competition_id: 19_806 },
      { name: 'La Liga', sport_monk_competition_id: 19_799 }
    ]
  end

  def get_fixtures(rounds, all_participants)
    fixtures = []
    rounds.each do |round|
      round['fixtures'].each do |fixture|
        parsed_fixture = parsed_fixtures(fixture, all_participants)
        fixtures << parsed_fixture
      end
    end
    fixtures
  end

  def parsed_fixtures(fixture, all_participants)
      fp = fixture['participants']
      home_team_id = nil
      away_team_id = nil

      fp.each do |participant|
        id = participant['id']
        if !all_participants.has_key?(id)
          all_participants[id] = { name: participant['name'], image_path: participant['image_path'] }
        end

        if participant['meta']['location'] == 'home'
          home_team_id = id
        elsif participant['meta']['location'] == 'away'
          away_team_id = id
        end
      end

      # using slice to include only the keys we want
      parsed_fixture = fixture.slice('id', 'season_id', 'round_id', 'name', 'starting_at', 'starting_at_timestamp', 'scores')

      parsed_fixture['home_team_id'] = home_team_id
      parsed_fixture['away_team_id'] = away_team_id

      parsed_fixture
  end

  def convert_participants_hash(all_participants)
    all_participants.map do |key, data|
      { id: key, name: data[:name], image_path: data[:image_path] }
    end
  end

  # Getting all Countries Ids
  def parse_all_countries(all_rounds)
    sportmonk_countries_data = all_rounds['data']
    results = []

    sportmonk_countries_data.each do |country|
      sport_monk_country_id = country['id']
      sport_monk_country_name = country['name']

      country_details = {
        "sport_monk_country_id": sport_monk_country_id,
        "name": sport_monk_country_name
      }
      results << country_details
    end
    results
  end

    # def parsed_participants(participants)
  #   participants.map { |participant| participant.slice('id','sport_id', 'country_id','name', 'short_code', 'image_path', 'last_played_at', 'meta',) }
  # end





  # Getting all Teams IDs
  # def parse_team_ids_from_first_round(round)
  #   teams = {}
  #   round['fixtures'].each do |fixture|
  #     fixture['participants'].each do |participant|
  #       sport_monk_team_id = participant['id']
  #       name = participant['name']
  #       teams[sport_monk_team_id] = name
  #     end
  #   end
  #   teams
  # end

  # # Getting information on all 38 rounds of the competition
  # def parse_rounds_details(rounds)
  #   rounds_data = []
  #   rounds.each_with_index do |round, index|
  #     start_time = round['starting_at']
  #     current_match_day = round['name']
  #     status = round['finished']
  #     sport_monk_round_id = round['id']

  #     round_details = {
  #       "sport_monk_round_id": sport_monk_round_id,
  #       "name": current_match_day,
  #       "starting_at": start_time,
  #       "finished": status,
  #       "game_round_number": index + 1
  #     }
  #     rounds_data << round_details
  #   end
  #   rounds_data
  # end

  # def find_target_round(rounds, target_round_name)
  #   rounds.find { |round| round['name'] == target_round_name.to_s }
  # end

  # # Checking if team is a winner or not in a given round
  # def parse_team_results_from_round(target_round)
  #   round_finished = target_round['finished']
  #   return puts "Round #{target_round} has not finished yet" unless round_finished

  #   fixtures = target_round['fixtures'].sort_by { |fixture| fixture['starting_at'] }
  #   results = []
  #   fixtures.each do |fixture|
  #     fixture.dig('participants')&.each do |participant|
  #       team_id = participant['id']
  #       team_name = participant['name']
  #       is_winner = participant.dig('meta', 'winner')
  #       results << { team_id: team_id, team_name: team_name, winner: is_winner }
  #     end
  #   end
  #   results
  # end

  # def extract_teams_info(fixture)
  #   home_team = ''
  #   away_team = ''
  #   winner_id = nil
  #   fixture.dig('participants')&.each do |participant|
  #     if participant.dig('meta', 'location') == 'home'
  #       home_team = participant['name']
  #     elsif participant.dig('meta', 'location') == 'away'
  #       away_team = participant['name']
  #     end
  #     winner_id = participant['id'] if participant.dig('meta', 'winner')
  #   end
  #   { home_team: home_team, away_team: away_team, winner_id: winner_id }
  # end




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


  # def parse_results_by_given_round(target_round_data)
  #   if target_round_data
  #     round_finished = target_round_data['finished']

  #     round_fixtures = []
  #     if round_finished
  #       fixtures = parsed_fixtures(target_round_data['fixtures']).sort_by { |fixture| fixture['starting_at'] }
  #       fixtures.each do |fixture|
  #         teams = extract_teams_info(fixture)

  #         # Get the final score of the fixture
  #         scores = fixture['scores']
  #         full_time = scores.select { |score| score['description'] == 'CURRENT' }
  #         home_score = full_time.find { |score| score['score']['participant'] == 'home' }&.dig('score', 'goals')
  #         away_score = full_time.find { |score| score['score']['participant'] == 'away' }&.dig('score', 'goals')

  #         # Determine the winner of the fixture
  #         winner = if home_score && away_score
  #           if home_score > away_score
  #             teams[:home_team]
  #           elsif home_score < away_score
  #             teams[:away_team]
  #           else
  #             "Draw"
  #           end
  #         end

  #         # Store the fixture information in a hash
  #         round_fixtures << teams.merge({ home_score: home_score, away_score: away_score, winner: winner })
  #       end
  #     end
  #     round_fixtures
  #   end
  # end

  # # Parsing fixtures from a given sport_monk_round_id
  # def parse_fixtures_by_given_round(fixtures)
  #   round_fixtures = []
  #   fixtures.sort_by { |fixture| fixture['starting_at'] }.each do |fixture|
  #     teams = extract_teams_info(fixture)
  #     starting_at = fixture['starting_at']
  #     round_fixtures << teams.merge(starting_at: starting_at)
  #   end
  #   round_fixtures
  # end

  # def parse_team_has_won?(fixtures)
  #   round_results = []
  #   fixtures.each do |fixture|
  #     fixture['participants'].each do |participant|
  #       id = participant['id']
  #       name = participant['name']
  #       winner = participant.dig('meta', 'winner')
  #       result_hash = { team_id: id, team_name: name, winner: winner.nil? ? false : winner }
  #       round_results << result_hash
  #     end
  #   end
  #   round_results
  # end
end
