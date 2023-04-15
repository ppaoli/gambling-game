class AddSportMonkParticipantIdToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :sport_monk_participant_id, :integer
  end
end
