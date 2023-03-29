class SportsMonkService
  include HTTParty
  base_uri 'https://api.sportmonks.com/v3/football'
  format :json

  def initialize
    @api_token = ENV['SPORTS_MONK_API_TOKEN']
  end

  def get_closest_upcoming_round_fixtures(season_id)
    response = HTTParty.get("#{self.class.base_uri}/rounds/seasons/#{season_id}",
      query: { 'include' => 'fixtures', 'api_token' => @api_token },
      headers: { 'Accept' => 'application/json' })

    data = JSON.parse(response.body)['data']

    closest_upcoming_round = nil
    min_time_difference = Float::INFINITY

    data.each do |round|
      round_starting_at = DateTime.parse(round['starting_at'])
      time_difference = (round_starting_at - DateTime.now).to_f

      if time_difference > 0 && time_difference < min_time_difference
        min_time_difference = time_difference
        closest_upcoming_round = round
      end
    end

    closest_upcoming_fixtures = closest_upcoming_round['fixtures']

    closest_upcoming_fixtures
  end
end
