class DayPartsController < ApplicationController
  before_action :set_day_part

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
end
