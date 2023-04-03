class RenameSportMonkIdColumnInSports < ActiveRecord::Migration[7.0]
  def change
    rename_column :sports, :sport_monk_id, :sport_monk_sport_id
  end
end
