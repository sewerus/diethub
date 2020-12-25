class TemplateDayPartMeal < ApplicationRecord
  belongs_to :template_day_part
  belongs_to :meal
end
