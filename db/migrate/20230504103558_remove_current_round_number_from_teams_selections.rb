class RemoveCurrentRoundNumberFromTeamsSelections < ActiveRecord::Migration[7.0]
  def change
    remove_column :teams_selections, :current_round_number, :integer
  end
end
