class Game < ApplicationRecord
  belongs_to :competition, optional: true
  belongs_to :user, optional: true
  has_many :game_rounds
  has_many :rounds, through: :game_rounds, dependent: :destroy
  has_many :game_invitations
  has_many :invited_users, through: :game_invitations, source: :user
  scope :private_games, -> { where(is_public: false) }
  validates :stake, presence: true, numericality: { greater_than_or_equal_to: 10 }
  has_many :games_enrollments, dependent: :destroy
  has_many :teams_selections, through: :games_enrollments
  validates :is_public, inclusion: { in: [true, false] }
  attribute :current_round_number, :integer
  validate :competition_id_exists, on: :create_public_game


  def update_entries_count
    self.entries = GamesEnrollment.where(game_id: id).count
    save
  end


  def deadline
    closest_upcoming_fixture = competition.closest_upcoming_round.fixtures.order(:starting_at).first
    (closest_upcoming_fixture.starting_at - 2.hours).in_time_zone(Time.zone)
  end


  MAX_ENTRIES_PER_USER = 3

  private

  def competition_id_exists
    errors.add(:competition_id, 'does not exist') unless Competition.exists?(id: competition_id)
  end
end
