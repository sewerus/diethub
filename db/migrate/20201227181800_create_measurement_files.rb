class CreateMeasurementFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :measurement_files do |t|
      t.belongs_to :measument
      t.string :measurement_file
      t.string :token
      t.timestamps
    end
  end
end
