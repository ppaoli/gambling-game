class AddSportMonkRoundIdToFixtures < ActiveRecord::Migration[7.0]
  def change
    add_column :fixtures, :sport_monk_round_id, :integer
  end
end
