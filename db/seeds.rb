# Create a football record in the sports table
Sport.find_or_create_by(sport_monk_sport_id: 1) do |football|
  football.name = 'Football'
end
