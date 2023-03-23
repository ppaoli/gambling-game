class CreateFixtures < ActiveRecord::Migration[7.0]
  def change
    create_table :fixtures do |t|
      t.date :date
      t.references :competition, null: false, foreign_key: true
      t.integer :home_team_id
      t.integer :away_team_id

      t.timestamps
    end
  end
end
