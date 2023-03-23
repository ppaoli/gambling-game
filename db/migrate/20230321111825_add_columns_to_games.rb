class AddColumnsToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :stake, :integer
    add_column :games, :start_date, :date
    add_column :games, :deadline, :date
    add_column :games, :num_players, :integer
    add_column :games, :title, :string
  end
end
