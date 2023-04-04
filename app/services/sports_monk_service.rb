class SportsMonkService
  include HTTParty
  base_uri 'https://api.sportmonks.com/v3/football'
  format :json

  def initialize
    @api_token = ENV['SPORTS_MONK_API_TOKEN']
  end


  def sportmonk_competitions_ids
   [
      { name: 'Premier League', sport_monk_competition_id: 19734 },
      { name: 'Bundesliga', sport_monk_competition_id: 19744 },
      { name: 'Ligue 1', sport_monk_competition_id: 19745 },
      { name: 'Serie A', sport_monk_competition_id: 19806 },
      { name: 'La Liga', sport_monk_competition_id: 19799 }
    ]
  end

  # sportmonk_competitions_ids.each do |comp|
  #   Competition.find_or_create_by(name: comp[:name], sport_monk_competition_id: comp[:sport_monk_competition_id])
  # end



  def get_sportmonk_competition_details(competition_id)
    response = self.class.get("/schedules/seasons/#{competition_id}",
      query: { 'api_token' => @api_token },
      headers: { 'Accept' => 'application/json' })
      puts response.body
    data = JSON.parse(response.body)['data']
    puts data
    first_fixture = data[0]["rounds"][0]['fixtures'][0]
    puts "First Fixture Is #{first_fixture}"
    sport_monk_country_id =first_fixture["participants"][0]["country_id"]
    puts "Country ID is #{sport_monk_country_id}"
    sport_monk_sport_id = first_fixture["participants"][0]["sport_id"]
    puts "Sport ID is #{sport_monk_sport_id}"

    {
      sport_monk_country_id: sport_monk_country_id,
      sport_monk_sport_id: sport_monk_sport_id,
    }
  end


  def get_countries
    url = "https://api.sportmonks.com/v3/core/countries?api_token=#{ENV['SPORTSMONK_API_TOKEN']}&include="
    response = HTTParty.get(url)
    sportmonk_countries_data = response['data']
    sportmonk_countries_data.each do |sportmonk_country_data|
      country = Country.find_by(id: sportmonk_country_data['id'])
      country.update(name: sportmonk_country_data['name']) if country
    end
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

    # Calculate deadline of entry to the game for participants
    deadline = DateTime.parse(closest_upcoming_fixtures.first['starting_at']) - Rational(2, 24)
    deadline = deadline.strftime('%Y-%m-%d %H:%M:%S')
    puts "Deadline: #{deadline}"

    return round_fixtures
  end

  # # Map competition to sport and country
  # def map_competition_to_sport_and_country(competition_id)
  #   url = "https://api.sportmonks.com/v3/football/schedules/seasons/#{competition_id}?api_token=#{ENV['SPORTSMONK_API_TOKEN']}"
  #   response = HTTParty.get(url)
  #   country_id = response['data']['participants'].first['country_id']
  #   sport_id = response['data']['sport_id']
  #   { sport_id: sport_id, country_id: country_id }
  # end

end
