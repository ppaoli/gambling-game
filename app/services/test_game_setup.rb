require_relative 'sports_monk_service'
require_relative 'sports_monk_parser'
require_relative 'game_setup'
include SportsMonkParser

# competition_id = 19734 # Replace with a valid competition ID for your case
# game_service = GameSetup::GameService.new(competition_id)

# game_service.setup

competition_ids = [19_734, 19_744, 19_745, 19_806, 19_799]

competition_ids.each do |competition_id|
  game_service = GameSetup::GameService.new(competition_id)
  game_service.setup
end

# Add any code here to check the results in the database

# Fetch and display records from the Fixture table
# puts "\nFixtures:"
# fixtures = Fixture.all
# fixtures.each do |fixture|
#   puts "#{fixture.id}: Home Team: #{fixture.home_team_id}, Away Team: #{fixture.away_team_id}, Starting At: #{fixture.starting_at}, Competition ID: #{fixture.competition_id}"
# end

# Fetch and display records from the Team table
# puts "\nTeams:"
# teams = Team.all
# teams.each do |team|
#   puts "#{team.id}: #{team.name}"
# end

# Fetch and display records from the Country table
puts "\nCountries:"
countries = Country.all
countries.each do |country|
  puts "#{country.id}: #{country.name}"
end
