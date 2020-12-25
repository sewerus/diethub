class TemplateDayPartsController < ApplicationController
  before_action :set_template_day_part, only: [:edit, :update, :destroy]
  before_action :set_template_day, only: [:new]
  before_action :admin_and_dietician_only, except: [:create]

  def new
    @template_day_part = TemplateDayPart.new
    @template_day_part.template_day = @template_day
  end

  def create
    @template_day_part = TemplateDayPart.new(template_day_part_params)
    admin_and_dietician_only

    if @template_day_part.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to template_day_parts_path(@template_day_part.template_day.patient), alert: 'Nie udało się zapisać zmian.'
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
      redirect_to template_day_parts_path(@template_day_part.template_day.patient), alert: 'Nie udało się zapisać zmian.'
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

  def admin_and_dietician_only
    if !(current_user.is_a? Admin) and !(!@template_day.nil? and @template_day.patient.dietician.id == current_user.id) and !(!@template_day_part.nil? and @template_day_part.patient.dietician.id == current_user.id)
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
