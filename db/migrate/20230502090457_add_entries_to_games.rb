class AddEntriesToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :entries, :integer
  end
end
