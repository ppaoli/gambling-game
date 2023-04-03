class AddNameToSports < ActiveRecord::Migration[7.0]
  def change
    add_column :sports, :name, :string
  end
end
