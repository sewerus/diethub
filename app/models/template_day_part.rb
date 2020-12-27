class TemplateDayPart < ApplicationRecord
  belongs_to :template_day
  has_many :template_day_part_meals, dependent: :destroy
  has_many :meals, through: :template_day_part_meals

  def can_show?(user)
    self.template_day.can_show?(user)
  end

  def can_edit?(user)
    self.template_day.can_edit?(user)
  end
end
