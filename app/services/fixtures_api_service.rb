class FixturesApiService
  include HTTParty

  BASE_URL = 'https://api.example.com'

  def fetch_fixtures
    response = self.class.get("#{BASE_URL}/fixtures")
    JSON.parse(response.body)
  end
end
