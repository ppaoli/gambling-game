class AddNumEntriesToGamesEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_column :games_enrollments, :num_entries, :integer
  end
end
