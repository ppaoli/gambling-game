class CreateGamesEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :games_enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
