class Training < ApplicationRecord
  belongs_to :patient

  scope :at_hour, -> (hour) {
    if hour == 6
      where("hour >= ?", 0).where("hour < ?", 7)
    elsif hour == 22
      where("hour >= ?", 22).where("hour <= ?", 23).where("minute <= ?", 59)
    else
      where("hour >= ?", hour).where("hour < ?", hour+1)
    end
  }

  def related_day
    self.patient.get_day(self.date)
  end
end
