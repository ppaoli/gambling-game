module Parser

  def parse_all_countries(response)
    sportmonk_countries_data = response['data']
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

  def parse_team_ids_from_first_round(round)
    teams = {}
    round['fixtures'].each do |fixture|
      fixture['participants'].each do |participant|
        sport_monk_team_id = participant['id']
        name = participant['name']
        teams[sport_monk_team_id] = name
      end
    end
    teams
  end

  def parse_rounds_details(rounds)
    rounds_data = []
    rounds.each do |round|
      start_time = round['starting_at']
      current_match_day = round['name']
      status = round['finished']
      sport_monk_round_id = round['id']

    round_details = {
      "sport_monk_round_id": sport_monk_round_id,
      "name": current_match_day,
      "starting_at": start_time,
      "finished": status
      #"round_number": index +1
    }
    rounds_data << round_details
    end
    rounds_data
  end

  def find_target_round(rounds, target_round_name)
    rounds.find { |round| round['name'] == target_round_name.to_s }
  end

  def parse_team_results_from_round(target_round)
    round_finished = target_round['finished']
    return puts "Round #{target_round} has not finished yet" unless round_finished

    fixtures = target_round['fixtures'].sort_by { |fixture| fixture['starting_at'] }
    results = []
    fixtures.each do |fixture|
      fixture.dig('participants')&.each do |participant|
        team_id = participant['id']
        team_name = participant['name']
        is_winner = participant.dig('meta', 'winner')
        results << {team_id: team_id, team_name: team_name, winner: is_winner }
      end
    end
    results
  end

  def parse_remaining_fixtures_by_round(rounds)
    remaining_fixtures = {}

    rounds.each do |round|
      round_name = round['name']
      round_finished = round['finished']

      next if round_finished

      fixtures = round['fixtures'].sort_by { |fixture| fixture['starting_at'] }
      upcoming_fixtures = []

      fixtures.each do |fixture|
        starting_at_utc = fixture['starting_at']
        current_time = Time.now.utc

        # Skip this fixture if it's in the past
        next if Time.parse(starting_at_utc) <= current_time

        home_team = ''
        away_team = ''
        fixture.dig('participants')&.each do |participant|
          if participant.dig('meta', 'location') == 'home'
            home_team = participant['name']
          elsif participant.dig('meta', 'location') == 'away'
            away_team = participant['name']
          end
        end

        upcoming_fixtures << { home_team: home_team, away_team: away_team, starting_at_utc: starting_at_utc }
      end

      remaining_fixtures[round_name] = upcoming_fixtures unless upcoming_fixtures.empty?
    end

    remaining_fixtures
  end

  def parse_results_by_given_round(target_round_data)
    if target_round_data
      round_name = target_round_data['name']
      round_finished = target_round_data['finished']

      round_fixtures = []
      if round_finished
        fixtures = target_round_data['fixtures'].sort_by { |fixture| fixture['starting_at'] }
        fixtures.each do |fixture|
          home_team = ''
          away_team = ''
          fixture.dig('participants')&.each do |participant|
            if participant.dig('meta', 'location') == 'home'
              home_team = participant['name']
            elsif participant.dig('meta', 'location') == 'away'
              away_team = participant['name']
            end
          end

          # Get the final score of the fixture
          scores = fixture['scores']
          full_time = scores.select { |score| score['description'] == 'CURRENT' }
          home_score = full_time.find { |score| score['score']['participant'] == 'home' }&.dig('score', 'goals')
          away_score = full_time.find { |score| score['score']['participant'] == 'away' }&.dig('score', 'goals')

          # Store the fixture information in a hash
          round_fixtures << { home_team: home_team, away_team: away_team, home_score: home_score, away_score: away_score }
        end
      end
    end
  end
end
