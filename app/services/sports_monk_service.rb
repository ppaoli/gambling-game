 require_relative 'parser'

class SportsMonkService
  include HTTParty
  include Parser
  base_uri 'https://api.sportmonks.com/v3/football'
  format :json


  def initialize
    @api_token = ENV['SPORTS_MONK_API_TOKEN']
  end



  def sportmonk_competitions_ids
   [
     { name: 'Premier League', sport_monk_competition_id: 19_734 },
     { name: 'Bundesliga', sport_monk_competition_id: 19_744 },
     { name: 'Ligue 1', sport_monk_competition_id: 19_745 },
     { name: 'Serie A', sport_monk_competition_id: 19_806 },
     { name: 'La Liga', sport_monk_competition_id: 19_799 }
   ]
  end


  def fetch_rounds_data(competition_id)
    response = self.class.get("/schedules/seasons/#{competition_id}",
    query: { 'api_token' => @api_token },
    headers: { 'Accept' => 'application/json' })
    data = JSON.parse(response.body)['data']
    data[0]['rounds']
  end

  def all_countries
    url = "https://api.sportmonks.com/v3/core/countries?api_token=#{ENV['SPORTS_MONK_API_TOKEN']}&include="
    response = HTTParty.get(url)
    parse_all_countries(response)
  end

  def fetch_first_round_data(competition_id)
    rounds_data = fetch_rounds_data(competition_id)
    rounds_data[0]
  end

  def fetch_team_ids(competition_id)
    first_round = fetch_first_round_data(competition_id)
    parse_team_ids_from_first_round(first_round)
  end

  def all_rounds_details(competition_id)
    rounds = fetch_rounds_data(competition_id)
    parse_rounds_details(rounds)
  end

  def round_team_results(competition_id, target_round_name)
    rounds = fetch_rounds_data(competition_id)
    target_round = find_target_round(rounds, target_round_name)

    return puts "Round #{target_round_name} not found" unless target_round

    puts "Round #{target_round_name}"
    parse_team_results_from_round(target_round)
  end

  def team_has_won?(competition_id, sport_monk_round_id)
    fixtures = fetch_round_fixtures(competition_id, sport_monk_round_id)
    round_results = []
    fixtures.each do |fixture|
      fixture['participants'].each do |participant|
        id = participant['id']
        name = participant['name']
        winner = participant.dig('meta', 'winner')
        result_hash = { team_id: id, team_name: name, winner: winner.nil? ? false : winner }
        round_results << result_hash
      end
    end
    round_results
  end

  def fetch_round_fixtures(competition_id, round_id)
    rounds = fetch_rounds_data(competition_id)
    specific_round = rounds.find { |round| round['id'] == round_id }
    specific_round['fixtures']
  end

  def remaining_fixtures(competition_id)
    rounds = fetch_rounds_data(competition_id)
    parse_remaining_fixtures_by_round(rounds)
  end

  def convert_utc_to_bst(utc_time_string)
    utc_time = Time.parse(utc_time_string)
    bst_time = utc_time.getlocal('+03:00')
    bst_time.strftime('%Y-%m-%d %H:%M:%S')
  end

  def fixtures_results(competition_id, target_round)
    rounds = fetch_rounds_data(competition_id)
    target_round_data = rounds.find { |round| round['name'] == target_round }
    parse_results_by_given_round(target_round_data)
  end

  def get_closest_upcoming_round_fixtures(competition_id)
    response = HTTParty.get("#{self.class.base_uri}/schedules/seasons/#{competition_id}",
      query: {'api_token' => @api_token },
      headers: { 'Accept' => 'application/json' })

    data = JSON.parse(response.body)['data']
    closest_upcoming_round = nil
    min_time_difference = Float::INFINITY

    data.each do |element|
      element['rounds'].each do |round|
        round_starting_at = DateTime.parse(round['starting_at'])
        time_difference = (round_starting_at - DateTime.now).to_f
        if time_difference > 0 && time_difference < min_time_difference
          min_time_difference = time_difference
          closest_upcoming_round = round
        end
      end
    end
    # puts "Closest upcoming round: #{closest_upcoming_round}"

    closest_upcoming_fixtures = closest_upcoming_round['fixtures']

    # Sort fixtures by starting time
    closest_upcoming_fixtures.sort_by! { |fixture| fixture['starting_at'] }

    # Display fixtures in chronological order
    round_fixtures = closest_upcoming_fixtures.each do |fixture|
      puts "Fixture: #{fixture['name']} (#{fixture['starting_at']})"
    end

    return round_fixtures
  end

  def get_deadline(closest_upcoming_fixtures)
    deadline = DateTime.parse(closest_upcoming_fixtures.first['starting_at']) - Rational(2, 24)
    deadline = deadline.strftime('%Y-%m-%d %H:%M:%S')
    puts "Deadline: #{deadline}"
  end

  def get_sportmonk_competition_details(competition_id)
    response = self.class.get("/schedules/seasons/#{competition_id}",
      query: { 'api_token' => @api_token },
      headers: { 'Accept' => 'application/json' })

    season_schedule = JSON.parse(response.body)['data']

    first_fixture = season_schedule[0]["rounds"][0]['fixtures'][0]
    # puts "First Fixture Is #{first_fixture}"
    sport_monk_country_id =first_fixture["participants"][0]["country_id"]
    # puts "Country ID is #{sport_monk_country_id}"
    sport_monk_sport_id = first_fixture["participants"][0]["sport_id"]
    # puts "Sport ID is #{sport_monk_sport_id}"

    {
      sport_monk_country_id: sport_monk_country_id,
      sport_monk_sport_id: sport_monk_sport_id,
    }
  end
end
