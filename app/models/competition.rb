class Competition < ApplicationRecord
  belongs_to :sport
  belongs_to :country
  has_many :games
  has_many :competitions_enrollments
  # validates :current_match_day, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
