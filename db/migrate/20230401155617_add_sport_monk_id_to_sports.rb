class AddSportMonkIdToSports < ActiveRecord::Migration[7.0]
  def change
    add_column :sports, :sport_monk_id, :integer
  end
end
