class FixEatenInDayPartMeals < ActiveRecord::Migration[5.2]
  def change
    change_column :day_part_meals, :eaten, :boolean, default: false
  end
end
