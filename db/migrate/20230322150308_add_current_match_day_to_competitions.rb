class AddCurrentMatchDayToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :current_match_day, :integer
  end
end
