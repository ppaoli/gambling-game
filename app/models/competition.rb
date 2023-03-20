class Competition < ApplicationRecord
  belongs_to :sport
  belongs_to :country
  has_many :games
  has_many :competitions_enrollments
end
