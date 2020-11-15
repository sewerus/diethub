class CreateDieticiansPatientsRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :dieticians_patients_relationships do |t|
      t.belongs_to :dietician
      t.belongs_to :patient
    end
  end
end
