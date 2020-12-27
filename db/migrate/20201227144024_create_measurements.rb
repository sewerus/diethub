class CreateMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :measurements do |t|
      t.belongs_to :patient
      t.date :date
      t.decimal :weight, precision: 7, scale: 2
      t.timestamps
    end
  end
end
