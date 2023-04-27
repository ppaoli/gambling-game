class AddCompetitionRefToRounds < ActiveRecord::Migration[7.0]
  def change
    add_reference :rounds, :competition, null: false, foreign_key: true
  end
end
