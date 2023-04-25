class AddFinishedToRounds < ActiveRecord::Migration[7.0]
  def change
    add_column :rounds, :finished, :boolean
  end
end
