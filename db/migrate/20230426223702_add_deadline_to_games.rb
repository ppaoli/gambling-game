class AddDeadlineToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :deadline, :datetime
  end
end
