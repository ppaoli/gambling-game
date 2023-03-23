class RenameAreaToStreetInUsers < ActiveRecord::Migration[7.0]
  def change
        rename_column :users, :area, :street
  end
end
