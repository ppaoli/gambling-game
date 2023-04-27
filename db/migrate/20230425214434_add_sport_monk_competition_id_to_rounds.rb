class AddSportMonkCompetitionIdToRounds < ActiveRecord::Migration[7.0]
  def change
    add_column :rounds, :sport_monk_competition_id, :integer
  end
end
