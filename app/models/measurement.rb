class Measurement < ApplicationRecord
  belongs_to :patient

  def related_day
    self.patient.get_day(self.date)
  end
end
