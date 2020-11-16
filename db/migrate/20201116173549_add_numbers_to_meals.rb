class AddNumbersToMeals < ActiveRecord::Migration[5.2]
  def change
    add_column :meals, :calories, :integer
    add_column :meals, :fat, :integer
    add_column :meals, :carbo, :integer
    add_column :meals, :protein, :integer
  end
end
