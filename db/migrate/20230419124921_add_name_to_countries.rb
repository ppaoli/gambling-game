class AddNameToCountries < ActiveRecord::Migration[7.0]
  def change
    add_column :countries, :name, :string
  end
end
