class AddMaxEntriesPerUserToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :max_entries_per_user, :integer, default: 2
  end
end
