class AddSportMonkRoundNameToRounds < ActiveRecord::Migration[7.0]
  def change
    add_column :rounds, :sport_monk_round_name, :integer
  end
end
