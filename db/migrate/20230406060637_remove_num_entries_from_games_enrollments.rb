class RemoveNumEntriesFromGamesEnrollments < ActiveRecord::Migration[7.0]
  def change
    remove_column :games_enrollments, :num_entries, :integer
  end
end

