class AddSportMonkFixtureIdToFixtures < ActiveRecord::Migration[7.0]
  def change
    add_column :fixtures, :sport_monk_fixture_id, :integer
  end
end
