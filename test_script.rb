require_relative 'config/environment'
require 'dotenv/load'

def test_closest_upcoming_fixtures
  sports_monk_service = SportsMonkService.new

  # List of season IDs for the leagues you are interested in
  season_ids = [19734, 19744, 19745, 19806, 19799]

  season_ids.each do |season_id|
    puts "Fetching closest upcoming fixtures for season_id: #{season_id}"
    fixtures = sports_monk_service.get_closest_upcoming_round_fixtures(season_id)

    if fixtures.empty?
      puts "No upcoming fixtures found for season_id: #{season_id}"
    else
       # Sort the fixtures by start date
       fixtures.sort_by! { |fixture| fixture['starting_at'] }

       fixtures.each do |fixture|
        puts "Fixture ID: #{fixture['id']}, Teams: #{fixture['name']}, Starting At: #{fixture['starting_at']}"
      end
    end

    puts "\n"
  end
end

test_closest_upcoming_fixtures
