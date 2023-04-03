class AddSportMonkCompetitionIdToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :sport_monk_competition_id, :integer
  end
end
