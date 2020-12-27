class DayPartsController < ApplicationController
  before_action :set_day_part
  before_action :check_access

  def show
  end

  def edit
  end

  def update
    @day_part.update_meals(params[:chosen_id])
    render :show
  end
  
  private

  def set_day_part
    @day_part = DayPart.find_by(id: params[:id])
    if @day_part.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanej części dnia"
    end
  end

  def check_access
    result = false
    if current_user.is_a? Admin
      result = true
    elsif !@day_part.nil?
      patient = @day_part.day.patient
      result = current_user.id == patient.id or current_user.id == patient.dietician.id
    end
    unless result
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
