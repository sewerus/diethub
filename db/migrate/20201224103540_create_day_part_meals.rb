class CreateDayPartMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :day_part_meals do |t|
      t.belongs_to :day_part
      t.belongs_to :meal
      t.boolean :eaten
      t.timestamps
    end
  end
end
