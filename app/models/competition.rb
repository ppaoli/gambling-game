class Competition < ApplicationRecord
  belongs_to :sport
  belongs_to :country
  has_many :games
  has_many :rounds
  has_many :competitions_enrollments

  def closest_upcoming_round
    rounds.where('starting_at > ?', Time.zone.now).order(:starting_at).first
  end
end
