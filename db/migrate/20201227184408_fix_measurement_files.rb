class FixMeasurementFiles < ActiveRecord::Migration[5.2]
  def change
    rename_column :measurement_files, :measument_id, :measurement_id
  end
end
