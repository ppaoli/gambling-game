class AddHomeAndAwayTeamNamesToFixtures < ActiveRecord::Migration[7.0]
  def change
    add_column :fixtures, :home_team_name, :string
    add_column :fixtures, :away_team_name, :string
  end
end
