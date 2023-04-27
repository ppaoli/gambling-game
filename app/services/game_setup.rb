module GameSetup
  include SportsMonkParser

  class GameService

    def initialize(competition_id)
      @competition_id = competition_id
      @api_service = SportsMonkService.new
      @data = @api_service.get_data(competition_id)
      @countries = @api_service.all_countries
      @parsed_data = nil
    end

    def parse_data
      @parsed_data = parsed_data(@data)
    end

    def setup
      parse_data()
      setup_competitions()
      setup_teams()
      setup_rounds()
      setup_countries()
      add_missing_countries()
    end

    def setup_competitions
      parsed_result = parsed_data(@data)
      competition_details = parsed_result[:competition]
      sport_monk_country_id = competition_details[:sport_monk_country_id]
      sport_monk_sport_id = competition_details[:sport_monk_sport_id]
      competition_name = competition_details[:name]

      country = Country.find_or_create_by(sport_monk_country_id: sport_monk_country_id)
      sport = Sport.find_or_create_by(sport_monk_sport_id: sport_monk_sport_id)

      Competition.find_or_create_by(sport_monk_competition_id: @competition_id) do |competition|
        competition.name = competition_name
        competition.country_id = country.id
        competition.sport_id = sport.id
        competition.sport_monk_sport_id = sport_monk_sport_id
        competition.sport_monk_country_id = sport_monk_country_id
      end
    end

    def setup_rounds
      parsed_rounds = @parsed_data[:rounds]
      all_fixtures = @parsed_data[:fixtures]
      competition = Competition.find_by(sport_monk_competition_id: @competition_id)
      parsed_rounds.each do |parsed_round|
        new_round = Round.find_or_create_by!(sport_monk_round_id: parsed_round[:id]) do |round|
          round.sport_monk_round_name = parsed_round[:name]
          round.starting_at = parsed_round[:starting_at]
          round.finished = parsed_round[:finished]
          round.competition_id = competition.id
        end
        round_fixtures = all_fixtures.select { |fixture| fixture['round_id'] == parsed_round[:id] }
        setup_fixtures(new_round.id, round_fixtures)
      end
      # puts "Created round with ID: #{new_round.id} and sport_monk_round_id: #{new_round.sport_monk_round_id} for competition with ID: #{competition.id} and sport_monk_competition_id: #{competition.sport_monk_competition_id}"
    end

    def setup_fixtures(round_id, round_fixtures)
      round_fixtures.each do |fixture_data|
        home_team_id = fixture_data['home_team_id']
        away_team_id = fixture_data['away_team_id']
        sport_monk_round_id = fixture_data['round_id']
        starting_at = DateTime.parse(fixture_data['starting_at'])

        competition = Competition.find_by(sport_monk_competition_id: @competition_id)
        if competition
          Fixture.find_or_create_by!(
            sport_monk_fixture_id: fixture_data['id']
          ) do |fixture|
            fixture.round_id = round_id
            fixture.home_team_id = home_team_id
            fixture.away_team_id = away_team_id
            fixture.starting_at = starting_at
            fixture.sport_monk_round_id = sport_monk_round_id
            fixture.competition_id = competition.id
            fixture.finished = !fixture_data['scores'].empty?

            home_team = Team.find_by(sport_monk_participant_id: home_team_id)
            away_team = Team.find_by(sport_monk_participant_id: away_team_id)

            fixture.home_team = home_team if home_team
            fixture.away_team = away_team if away_team
            fixture.home_team_name = home_team.name if home_team
            fixture.away_team_name = away_team.name if away_team
          end
        end
      end
    end


    def setup_teams
      teams = @parsed_data[:participants]
      teams.each do |team|
        Team.find_or_create_by(sport_monk_participant_id: team[:id]) do |t|
          t.name = team[:name]
          t.image_path = team[:image_path]
        end
      end
    end

        #Save for later use
        # if fixture.finished
        #   target_round = round.sport_monk_round_name
        #   results = fetch_results(target_round)
        #   fixture_result = results.find { |result| result[:home_team] == home_team && result[:away_team] == away_team }
        #   if fixture_result
        #     fixture.update(
        #       home_score: fixture_result[:home_score],
        #       away_score: fixture_result[:away_score],
        #       winner: fixture_result[:winner] == "Draw" ? nil : fixture_result[:winner]
        #     )
        #   end
        # end
    #   end
    # end


    def setup_countries
      @countries.each do |country|
        Country.find_or_create_by(sport_monk_country_id: country[:sport_monk_country_id]) do |new_country|
          new_country.name = country[:name]
        end
      end
    end

    def add_missing_countries
      missing_countries = [
        { sport_monk_country_id: 462, name: 'England' },
        { sport_monk_country_id: 251, name: 'Italy' }
      ]
      missing_countries.each do |country|
        existing_country = Country.find_by(sport_monk_country_id: country[:sport_monk_country_id])
        if existing_country.nil?
          Country.create(sport_monk_country_id: country[:sport_monk_country_id], name: country[:name])
          puts "Creating new country #{country[:name]}"
        elsif existing_country.name.nil?
          existing_country.update(name: country[:name])
          puts "Updating existing country #{country[:name]}"
        end
      end
    end


    # def add_missing_countries
    #   missing_countries = [
    #     { sport_monk_country_id: 251, name: 'Italy' },
    #     { sport_monk_country_id: 462, name: 'England' },
    #   ]
    #   missing_countries.each do |country|
    #     Country.find_or_create_by(sport_monk_country_id: country[:sport_monk_country_id]) do |new_country|
    #       new_country.name = country[:name]
    #     end
    #   end
    # end
  end
end
