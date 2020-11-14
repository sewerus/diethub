module UsersHelper
  def user_path(user)
    if user.is_a? Admin
      admin_path(user)
    elsif user.is_a? Dietician
      dietician_path(user)
    elsif user.is_a? Patient
      patient_path(user)
    else
      ""
    end
  end
end
