class TemplateDay < ApplicationRecord
  belongs_to :patient
  has_many :template_day_parts, dependent: :destroy
  has_many :meals, through: :template_day_parts
  has_many :days
end
