class Game < ApplicationRecord
  belongs_to :competition, optional: true
  belongs_to :user, optional: true
  has_many :rounds
  has_many :game_invitations
  has_many :invited_users, through: :game_invitations, source: :user
  scope :private_games, -> { where(is_public: false) }
  validates :stake, presence: true, numericality: { greater_than_or_equal_to: 10 }
  has_many :games_enrollments
  validates :is_public, inclusion: { in: [true, false] }

  # Adding this line to validate the deadline
  validate :deadline_in_future, on: :create
  validate :competition_id_exists, on: :create_public_game

  private

  # Add this method to check if the deadline is in the future
  def deadline_in_future
    if deadline.present? && deadline < Time.current
      errors.add(:deadline, 'must be in the future')
    end
  end

  def competition_id_exists
    errors.add(:competition_id, 'does not exist') unless Competition.exists?(id: competition_id)
  end
end
