class DayPart < ApplicationRecord
  belongs_to :day
  has_many :day_part_meals, dependent: :destroy
  has_many :meals, through: :day_part_meals

  scope :at_hour, -> (hour) {
    if hour == 6
      where("hour >= ?", 0).where("hour < ?", 7)
    elsif hour == 22
      where("hour >= ?", 22).where("hour <= ?", 23).where("minute <= ?", 59)
    else
      where("hour >= ?", hour).where("hour < ?", hour+1)
    end
  }

  def eaten_all?
    self.day_part_meals.where(eaten: false).empty?
  end

  def update_meals(template_day_part_id)
    template_day_part = TemplateDayPart.find_by(id: template_day_part_id)
    unless template_day_part.nil?
      self.meals.clear
      self.meals += template_day_part.meals
    end
  end
end
