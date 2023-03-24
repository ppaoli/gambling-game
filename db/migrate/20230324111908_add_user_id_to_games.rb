class AddUserIdToGames < ActiveRecord::Migration[7.0]
  def change
    add_reference :games, :user, null: false, foreign_key: true
  end
end
