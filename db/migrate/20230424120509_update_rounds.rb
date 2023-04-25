class UpdateRounds < ActiveRecord::Migration[7.0]
  def change
    change_column_null :rounds, :game_id, true
  end
end
