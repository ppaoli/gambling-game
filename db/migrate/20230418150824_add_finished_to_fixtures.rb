class AddFinishedToFixtures < ActiveRecord::Migration[7.0]
  def change
    add_column :fixtures, :finished, :boolean
  end
end
