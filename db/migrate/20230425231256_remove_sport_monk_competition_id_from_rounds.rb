class RemoveSportMonkCompetitionIdFromRounds < ActiveRecord::Migration[7.0]
  def change
    remove_column :rounds, :sport_monk_competition_id, :integer
  end
end
