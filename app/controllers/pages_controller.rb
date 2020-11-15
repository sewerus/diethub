class PagesController < ApplicationController
  before_action :authenticate_user!

  def start_page
    if current_user.is_a? Admin
      redirect_to users_path
    elsif current_user.is_a? Dietician
      redirect_to my_patients_path
    elsif current_user.is_a? Patient
      redirect_to user_path(current_user)
    else
      redirect_to user_path(current_user)
    end
  end

end
