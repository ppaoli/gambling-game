class CreateGameRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :game_rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true
      t.integer :game_round_number, null: false

      t.timestamps
    end
    add_index :game_rounds, [:game_id, :round_id], unique: true
  end
end
