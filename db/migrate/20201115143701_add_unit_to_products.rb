class AddUnitToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :unit, :string
    add_column :products, :unit_amount, :integer
  end
end
