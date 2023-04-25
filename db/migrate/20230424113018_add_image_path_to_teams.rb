class AddImagePathToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :image_path, :string
  end
end
