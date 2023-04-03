class RenameSportMonkIdColumnInCountries < ActiveRecord::Migration[7.0]
  def change
    rename_column :countries, :sport_monk_id, :sport_monk_country_id
  end
end
