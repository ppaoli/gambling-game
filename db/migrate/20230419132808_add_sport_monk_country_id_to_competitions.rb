class AddSportMonkCountryIdToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_column :competitions, :sport_monk_country_id, :integer
  end
end
