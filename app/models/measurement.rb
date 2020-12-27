class Measurement < ApplicationRecord
  belongs_to :patient
  has_many :measurement_files, dependent: :destroy

  def related_day
    self.patient.get_day(self.date)
  end
  
  def add_measurement_files_by_tokens(token)
    if !token.nil? and !token.empty?
      MeasurementFile.where(token: token).each do |file|
        file.measurement = self
        file.token = nil
        file.save
      end
    end
  end

  def to_destroy?
    self.weight.to_f == 0.0 and self.sleep_time.to_f == 0.0 and self.measurement_files.empty?
  end
end
