class AddTeamNameToTeamsSelections < ActiveRecord::Migration[7.0]
  def change
    add_column :teams_selections, :team_name, :string
  end
end
