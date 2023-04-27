class RemoveStartDateFromGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :start_date, :date
  end
end
