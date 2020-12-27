class AddPatientandDateToTrainings < ActiveRecord::Migration[5.2]
  def change
    add_column :trainings, :patient_id, :integer
    add_column :trainings, :date, :date
    remove_column :trainings, :day_id
  end
end
