class GamePolicy < ApplicationPolicy
  class Scope < Scope
    def show?
      # Any person can view public games, and invited users can view private games.
      record.is_public? || record.invited_users.include?(user)
    end

    def join?
      # Only registered users can join games.
      user.present?
    end
  end
end
