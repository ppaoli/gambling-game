class RenameColumnNameInTeamSelections < ActiveRecord::Migration[7.0]
  def change
    rename_column :teams_selections, :sport_monk_team_id, :sport_monk_participant_id
  end
end
