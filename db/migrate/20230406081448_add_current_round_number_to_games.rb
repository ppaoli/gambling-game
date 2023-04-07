class AddCurrentRoundNumberToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :current_round_number, :integer
  end
end
