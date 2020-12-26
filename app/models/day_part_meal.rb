class DayPartMeal < ApplicationRecord
  belongs_to :day_part
  belongs_to :meal

  def set_as_eaten
    self.update(eaten: true)
  end
end
