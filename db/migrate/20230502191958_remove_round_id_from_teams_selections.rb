class RemoveRoundIdFromTeamsSelections < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :teams_selections, :rounds
  end
end
