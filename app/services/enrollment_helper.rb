module EnrollmentHelper
  class << self
    def join_game(user, game, num_entries)
      return :game_not_found unless game
      return :deadline_passed unless deadline_not_passed(game)
      return :user_not_found unless user
      return :too_many_entries if num_entries > Game::MAX_ENTRIES_PER_USER

      existing_enrollments = GamesEnrollment.where(user_id: user.id, game_id: game.id).count
      return :already_joined_game if existing_enrollments + num_entries > Game::MAX_ENTRIES_PER_USER

      entries_created = 0
      ActiveRecord::Base.transaction do
        num_entries.times do |n|
          entry_id = "#{user.id}-#{game.id}-#{n + existing_enrollments + 1}"
          enrollment = GamesEnrollment.new(user_id: user.id, game_id: game.id, entry_id: entry_id)
          enrollment.save!
          entries_created += 1
        end
      end

      entries_created
    end

    def leave_game(user, game)
      enrollment = GamesEnrollment.where(user_id: user.id, game_id: game.id)
      if deadline_not_passed(game) && enrollment.exists?
        enrollment.destroy_all
        true
      else
        false
      end
    end

    def change_entries(user, game, num_entries)
      return :deadline_passed unless deadline_not_passed(game)
      return :too_many_entries if num_entries > Game::MAX_ENTRIES_PER_USER

      existing_enrollments = GamesEnrollment.where(user_id: user.id, game_id: game.id).count
      return :already_joined_game if existing_enrollments == num_entries

      if existing_enrollments > num_entries
        enrollments_to_remove = existing_enrollments - num_entries
        ActiveRecord::Base.transaction do
          GamesEnrollment.where(user_id: user.id, game_id: game.id).last(enrollments_to_remove).destroy_all
        end
        enrollments_to_remove
      elsif existing_enrollments < num_entries
        enrollments_to_create = num_entries - existing_enrollments
        ActiveRecord::Base.transaction do
          enrollments_to_create.times do |n|
            entry_id = "#{user.id}-#{game.id}-#{n + existing_enrollments + 1}"
            enrollment = GamesEnrollment.new(user_id: user.id, game_id: game.id, entry_id: entry_id)
            enrollment.save!
          end
        end
        enrollments_to_create
      else
        0
      end
    end

    private

    def deadline_not_passed(game)
      game.closest_upcoming_fixture.starting_at > Time.zone.now
    rescue NoMethodError
      false
    end
  end
end
