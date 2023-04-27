class ChangeDefaultValueOfMaxEntriesPerUser < ActiveRecord::Migration[7.0]
  def change
    change_column_default :games, :max_entries_per_user, 3
  end
end
