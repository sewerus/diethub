class DayPartMealsController < ApplicationController
  before_action :set_day_part_meal
  before_action :check_access

  def set_as_eaten
    @day_part_meal.set_as_eaten
  end
  
  private

  def set_day_part_meal
    @day_part_meal = DayPartMeal.find_by(id: params[:id])
    if @day_part_meal.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanej części dnia"
    end
  end

  def check_access
    result = false
    if current_user.is_a? Admin
      result = true
    elsif !@day_part_meal.nil?
      patient = @day_part_meal.day_part.day.patient
      result = current_user.id == patient.id or current_user.id == patient.dietician.id
    end
    unless result
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
