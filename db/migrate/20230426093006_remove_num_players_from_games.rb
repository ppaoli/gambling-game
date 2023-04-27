class RemoveNumPlayersFromGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :num_players, :integer
  end
end
