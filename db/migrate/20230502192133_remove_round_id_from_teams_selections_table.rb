class RemoveRoundIdFromTeamsSelectionsTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :teams_selections, :round_id
  end
end
