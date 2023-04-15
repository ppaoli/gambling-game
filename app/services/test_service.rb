require_relative 'sports_monk_service'

# Create a new instance of the SportsMonkService class
service = SportsMonkService.new

# Call one of the methods to test it
rounds_data = service.fetch_rounds_data('19734')
puts rounds_data

# Call another method to test it
team_ids = service.fetch_team_ids('19734')
puts team_ids
