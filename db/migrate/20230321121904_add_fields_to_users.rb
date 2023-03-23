class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :mobile_number, :string
    add_column :users, :gender, :string
    add_column :users, :address, :string
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :area, :string
    add_column :users, :postal_code, :string
    add_column :users, :username, :string
    add_column :users, :date_of_birth, :date
  end
end
