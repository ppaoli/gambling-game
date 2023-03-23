require 'httparty'

class FootballDataService
  include HTTParty

  BASE_URL = 'https://api.football-data.org/v4/competitions/PL/matches?matchday=29'.freeze
  API_KEY = '0e016c768b484f5597f4d5ea046239f3'.freeze

  def initialize
    @options = {
      headers: {
        'X-Auth-Token' => API_KEY
      }
    }
  end

  def get_competitions
    response = self.class.get("#{BASE_URL}/competitions", @options)
    parse_response(response)
  end

  def get_matches(competition_id)
    response = self.class.get("#{BASE_URL}/competitions/#{competition_id}/matches", @options)
    parse_response(response)
  end

  private

  def parse_response(response)
    if response.success?
      response.parsed_response
    else
      raise "API request failed with status code: #{response.code}"
    end
  end
end
