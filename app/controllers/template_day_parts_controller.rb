class TemplateDayPartsController < ApplicationController
  before_action :set_template_day_part, only: [:edit, :update, :destroy]
  before_action :set_template_day, only: [:new]
  before_action :check_access, except: [:new, :create]

  def new
    @template_day_part = TemplateDayPart.new
    @template_day_part.template_day = @template_day
    check_access
  end

  def create
    @template_day_part = TemplateDayPart.new(template_day_part_params)
    check_access

    if @template_day_part.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to template_days_path(@template_day_part.template_day.patient), alert: 'Nie udało się zapisać zmian.'
    end
  end

  def edit
  end

  def update
    if @template_day_part.update_attributes(template_day_part_params)
      respond_to do |format|
        format.js
      end
    else
      redirect_to template_days_path(@template_day_part.template_day.patient), alert: 'Nie udało się zapisać zmian.'
    end
  end

  def destroy
    @template_day_part.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def template_day_part_params
    params.require(:template_day_part).permit(:title, :template_day_id, :hour, :minute, :time_margin, :description)
  end

  def set_template_day_part
    @template_day_part = TemplateDayPart.find_by(id: params[:id])
    if @template_day_part.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego szablonu dnia"
    end
  end

  def set_template_day
    @template_day = TemplateDay.find_by(id: params[:id])
    if @template_day.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego szablonu dnia"
    end
  end

  #admin has access to everything
  #new, create, edit, update, destroy -> dietician
  def check_access
    result = false
    if current_user.is_a? Admin
      result = true
    elsif !@template_day_part.nil?
      result = @template_day_part.patient.dietician.id == current_user.id
    end
    unless result
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
