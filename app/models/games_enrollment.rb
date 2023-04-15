class GamesEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :teams_selections, dependent: :destroy
  enum status: { eliminated: 0, active: 1, winner: 2 }
  # validates :num_entries, inclusion: { in: 1..2 }
  before_create :set_default_status
  validates :user_id, uniqueness: { scope: %i[game_id entry_id] }

  private

  def set_default_status
    Rails.logger.debug("Setting default status for GamesEnrollment")
    self.status ||= :active
  end
end

