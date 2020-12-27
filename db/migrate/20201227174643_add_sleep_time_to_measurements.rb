class AddSleepTimeToMeasurements < ActiveRecord::Migration[5.2]
  def change
    add_column :measurements, :sleep_time, :integer
    remove_column :days, :sleep_time
  end
end
