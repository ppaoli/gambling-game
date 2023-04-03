class AddSportMonkIdToCountries < ActiveRecord::Migration[7.0]
  def change
    add_column :countries, :sport_monk_id, :integer
  end
end
