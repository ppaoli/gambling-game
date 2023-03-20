class CreateTeamsSelections < ActiveRecord::Migration[7.0]
  def change
    create_table :teams_selections do |t|
      t.references :games_enrollment, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
