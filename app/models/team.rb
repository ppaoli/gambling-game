class Team < ApplicationRecord
  has_many :competitions_enrollments
  has_many :teams_selections
  has_many :competitions, through: :competitions_enrollment
end
