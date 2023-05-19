class AddRoundIdToTeamsSelections < ActiveRecord::Migration[7.0]
  def change
    add_reference :teams_selections, :round, null: false, foreign_key: true
  end
end
