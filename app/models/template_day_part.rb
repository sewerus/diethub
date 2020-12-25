class TemplateDayPart < ApplicationRecord
  belongs_to :template_day
  has_many :template_day_part_meals, dependent: :destroy
  has_many :meals, through: :template_day_part_meals
end
