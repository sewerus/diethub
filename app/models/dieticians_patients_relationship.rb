class DieticiansPatientsRelationship < ApplicationRecord
  belongs_to :patient, class_name: "Patient"
  belongs_to :dietician, class_name: "Dietician"
  validates :patient_id, presence: true
  validates :dietician_id, presence: true
end
