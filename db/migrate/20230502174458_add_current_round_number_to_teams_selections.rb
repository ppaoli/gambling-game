class AddCurrentRoundNumberToTeamsSelections < ActiveRecord::Migration[7.0]
  def change
    add_column :teams_selections, :current_round_number, :integer
  end
end
