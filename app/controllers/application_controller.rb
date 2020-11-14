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
end
