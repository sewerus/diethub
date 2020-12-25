class CreateTemplateDayPartMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :template_day_part_meals do |t|
      t.belongs_to :template_day_part
      t.belongs_to :meal
      t.timestamps
    end
  end
end
