class AddStartingAtToRounds < ActiveRecord::Migration[7.0]
  def change
    add_column :rounds, :starting_at, :datetime
  end
end
