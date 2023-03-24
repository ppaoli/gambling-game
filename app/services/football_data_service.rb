require 'httparty'

class FootballDataService
  include HTTParty

  BASE_URL = 'https://api.sportmonks.com/v3.0/'.freeze
  API_KEY = 'SujJu27YtP7QYvKwMRiF2wJUaZyz4MGsuuXsYkkCF3AwA3FhEYDurqkhdWwn'.freeze

  def initialize
    @options = {
      headers: {
        'Accept': 'application/json',
        'Authorization': "Bearer #{API_KEY}"
      }
    }
  end

  def get_fixtures(competition_id, season_id, round_id)
    response = self.class.get("#{BASE_URL}fixtures?competition_id=#{competition_id}&season_id=#{season_id}&round_id=#{round_id}", @options)
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
