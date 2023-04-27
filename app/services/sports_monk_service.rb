class SportsMonkService
  include HTTParty
  include SportsMonkParser
  base_uri 'https://api.sportmonks.com/v3/football'
  format :json


  def initialize
    @api_token = ENV['SPORTS_MONK_API_TOKEN']
  end


  def get_data(competition_id)
    response = self.class.get("/schedules/seasons/#{competition_id}",
    query: { 'api_token' => @api_token },
    headers: { 'Accept' => 'application/json' })
    data = JSON.parse(response.body)['data']
    all_rounds = data[0]['rounds']
    all_rounds
  end

  def all_countries
    url = "https://api.sportmonks.com/v3/core/countries?api_token=#{ENV['SPORTS_MONK_API_TOKEN']}&include="
    response = HTTParty.get(url)
    parse_all_countries(response)
  end
end
