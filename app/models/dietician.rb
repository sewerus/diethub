class Dietician < User
  #patients
  has_many :patients_relationships, class_name: "DieticiansPatientsRelationship",
           foreign_key: "dietician_id",
           dependent: :destroy
  has_many :patients, through: :patients_relationships, source: :patient
end
