class DayPartMealsController < ApplicationController
  before_action :set_day_part_meal

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
end
