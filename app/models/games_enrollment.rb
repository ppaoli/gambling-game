class GamesEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :teams_selections
  enum status: { eliminated: 0, active: 1, winner: 2 }

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= :active
  end
end
