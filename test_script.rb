require_relative 'config/environment'
require 'dotenv/load'

def sports_monk_service
  @sports_monk_service ||= SportsMonkService.new
end

def fetch_countries
  countries = sports_monk_service.all_countries
  puts "Fetched countries: #{countries}"
end

def test_team_ids
  puts sports_monk_service.fetch_team_ids('19734')
end

def test_get_all_rounds
  sports_monk_service.fetch_rounds_data('19744')
end

def test_round_details
  rounds = sports_monk_service.all_rounds_details('19734')
  puts rounds
end

def test_get_all_fixtures_by_round
  sports_monk_service.fetch_all_fixtures_by_round('19734')
end

def test_round_team_winners
  results = sports_monk_service.round_team_results('19734', '9')
  puts results
end


def test_round_results
  round_result = sports_monk_service.team_has_won?('19734', 274_669)
  puts "Fetching results for round_id 274669: #{round_result}"
end

def list_remaining_fixtures
  sports_monk_service.remaining_fixtures('19734')
end

def test_results
  sports_monk_service.fixtures_results('19734', '27')
end

def test_closest_fixtures
  sports_monk_service.get_closest_upcoming_round_fixtures('19734')
end

def competition_details
  details = sports_monk_service.get_sportmonk_competition_details('19734')
  puts details
end

# Fetches all countries with their id & name
# fetch_countries

# Fetches all teams in a competition with their id & name
# test_team_ids

# Fetches all 38 rounds of the competition
# test_get_all_rounds

# Lists each round with its id, name, date and if finished or not
 test_round_details

# Fetches all fixtures of the competition by round
# test_get_all_fixtures_by_round

# Checks if a team has won or not by round name
# test_round_team_winners

# Checks if a team has won or not by round id
#test_round_results

# Displays the remaining fixtures of the competition by round
# list_remaining_fixtures

# Displays the results of all games of the competition so far
 #test_results

# Fetches the closest upcoming round of fixtures compared to today's date:
# test_closest_fixtures

# Fetches the country id and sport id of a given competition
# competition_details
