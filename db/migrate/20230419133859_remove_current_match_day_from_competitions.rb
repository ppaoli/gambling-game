class RemoveCurrentMatchDayFromCompetitions < ActiveRecord::Migration[7.0]
  def change
    remove_column :competitions, :current_match_day
  end
end
