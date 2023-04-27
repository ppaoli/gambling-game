class Team < ApplicationRecord
  has_many :competitions_enrollments
  has_many :teams_selections
  has_many :competitions, through: :competitions_enrollment
  has_many :home_fixtures, class_name: 'Fixture', foreign_key: 'home_team_id'
  has_many :away_fixtures, class_name: 'Fixture', foreign_key: 'away_team_id'
end 
