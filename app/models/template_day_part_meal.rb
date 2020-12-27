class TemplateDayPartMeal < ApplicationRecord
  belongs_to :template_day_part
  belongs_to :meal

  def can_show?(user)
    self.template_day_part.can_show?(user)
  end

  def can_edit?(user)
    self.template_day_part.can_edit?(user)
  end
end
