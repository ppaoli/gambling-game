class AddWinnerIdAndRoundIdToFixtures < ActiveRecord::Migration[7.0]
  def change
    add_column :fixtures, :winner_id, :integer
    add_reference :fixtures, :round, null: false, foreign_key: true
  end
end
