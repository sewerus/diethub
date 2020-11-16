class CreateMealsProductsRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :meals_products_relationships do |t|
      t.belongs_to :meal
      t.belongs_to :product
      t.decimal :units_amount, precision: 7, scale: 2
      t.timestamps
    end
  end
end
