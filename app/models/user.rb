class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  #validates :username, presence: true
  has_many :games_enrollments
  has_many :games, through: :games_enrollment
  has_many :game_invitations
  has_many :invited_games, through: :game_invitations, source: :game
end
