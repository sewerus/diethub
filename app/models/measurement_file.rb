class MeasurementFile < ApplicationRecord
  belongs_to :measurement, optional: true
  mount_uploader :measurement_file, MeasurementFileUploader

  after_destroy :check_measurement

  def type
    self.measurement_file.to_s.from(self.measurement_file.to_s.rindex('.'))
  end

  def check_measurement
    measurement = self.measurement
    if measurement.to_destroy?
      measurement.destroy
    end
  end
end
