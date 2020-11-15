class ApplicationController < ActionController::Base
  def admin_only
    unless current_user.is_a? Admin
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end

  def admin_and_dieticians_only
    if !(current_user.is_a? Admin) and !(current_user.is_a? Dietician)
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end

  def who_has_access_to_user(user)
    unless current_user.has_access_to_user?(user.id)
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end

  def who_can_show_user(user)
    unless current_user.can_show_user?(user.id)
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end

  def who_can_reset_password(user)
    unless current_user.can_reset_password?(user.id)
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
