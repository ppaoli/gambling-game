class RemoveDeadlineFromGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :deadline, :datetime
  end
end
