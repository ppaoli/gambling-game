class ModifyFixturesAndRounds < ActiveRecord::Migration[7.0]
  def change
    change_table :fixtures do |t|
      t.rename :date, :starting_at
      t.change :starting_at, :datetime
    end

    change_table :rounds do |t|
      t.change :sport_monk_round_name, :string
    end
  end
end
