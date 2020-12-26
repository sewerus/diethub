class Patient < User
  #dietician
  has_one :dieticians_relationship, class_name:  "DieticiansPatientsRelationship",
           foreign_key: "patient_id", dependent:   :destroy
  has_one :dietician, through: :dieticians_relationship, source: :dietician

  #template_days
  has_many :template_days, dependent: :destroy

  #days
  has_many :days, dependent: :destroy

  def update_dietician(new_dietician_id = nil)
    unless self.dieticians_relationship.nil?
      self.dieticians_relationship.destroy
    end
    unless new_dietician_id.nil?
      self.dietician = Dietician.find(new_dietician_id)
    end
  end

  def update(params)
    super(params.except(:dietician_id))
    self.update_dietician(params[:dietician_id])
  end

  def dietician_id
    if self.dietician.nil?
      nil
    else
      self.dietician.id
    end
  end

  def get_day(date)
    self.days.where(date: date).first
  end
end
