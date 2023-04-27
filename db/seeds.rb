require_relative '../app/services/sports_monk_service'
require_relative '../app/services/sports_monk_parser'
require_relative '../app/services/game_setup'
include SportsMonkParser

competition_ids = [19734, 19744, 19745, 19806, 19799]

competition_ids.each do |competition_id|
  game_service = GameSetup::GameService.new(competition_id)
  game_service.setup
end

# Create a football record in the sports table
Sport.find_or_create_by(sport_monk_sport_id: 1) do |football|
  football.name = 'Football'
end
