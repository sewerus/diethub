class AddPersonalDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :tel, :string
    add_column :users, :pesel, :string
    add_column :users, :city, :string
    add_column :users, :street, :string
    add_column :users, :post_code, :string
  end
end
