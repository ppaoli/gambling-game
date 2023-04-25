class AddSportMonkSportIdToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :sport_monk_sport_id, :integer
  end
end
