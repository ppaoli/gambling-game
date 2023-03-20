class CreateCompetitionsEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions_enrollments do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
