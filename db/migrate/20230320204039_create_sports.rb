class CreateSports < ActiveRecord::Migration[7.0]
  def change
    create_table :sports do |t|

      t.timestamps
    end
  end
end
