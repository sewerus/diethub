class TemplateDay < ApplicationRecord
  belongs_to :patient
  has_many :template_day_parts, dependent: :destroy
  has_many :meals, through: :template_day_parts
  has_many :days

  def can_show?(user)
    if user.is_a? Admin
      true
    elsif user.id == patient.id
      true
    elsif user.id == patient.dietician.id
      true
    else
      false
    end
  end

  def can_edit?(user)
    if user.is_a? Admin
      true
    elsif user.id == patient.dietician.id
      true
    else
      false
    end
  end
end
