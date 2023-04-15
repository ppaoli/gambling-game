class AddSportMonkTeamIdToTeamsSelections < ActiveRecord::Migration[7.0]
  def change
    add_column :teams_selections, :sport_monk_team_id, :integer
  end
end
