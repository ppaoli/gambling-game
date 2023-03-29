class Game < ApplicationRecord
  belongs_to :competition
  belongs_to :user
  has_many :rounds
  has_many :game_invitations
  has_many :invited_users, through: :game_invitations, source: :user
  scope :private_games, -> { where(is_public: false) }
  validates :stake, presence: true, numericality: { greater_than_or_equal_to: 10 }
  has_many :games_enrollments
  validates :is_public, inclusion: { in: [true, false] }

  # Adding this line to validate the deadline
  validate :deadline_in_future, on: :create

  private

  # Add this method to check if the deadline is in the future
  def deadline_in_future
    if deadline.present? && deadline < Time.current
      errors.add(:deadline, 'must be in the future')
    end
  end
end
