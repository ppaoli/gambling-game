class CreateGameInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :game_invitations do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
