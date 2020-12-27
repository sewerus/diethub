class TemplateDaysController < ApplicationController
  before_action :set_template_day, only: [:edit, :update, :destroy]
  before_action :set_patient, only: [:index, :new]
  before_action :check_access, except: [:new, :create]
  
  def index
  end
  
  def new
    @template_day = TemplateDay.new
    @template_day.patient = @patient
    check_access
  end
  
  def create
    @template_day = TemplateDay.new(template_day_params)
    check_access

    if @template_day.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to template_days_path(@template_day.patient), alert: 'Nie udało się utworzyć nowego szablonu dnia.'
    end
  end
  
  def edit
  end
  
  def update
    if @template_day.update_attributes(template_day_params)
      respond_to do |format|
        format.js
      end
    else
      redirect_to template_days_path(@template_day.patient), alert: 'Nie udało się zapisać zmian.'
    end
  end
  
  def destroy
    @template_day.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def template_day_params
    params.require(:template_day).permit(:patient_id, :title)
  end

  def set_template_day
    @template_day = TemplateDay.find_by(id: params[:id])
    if @template_day.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego szablonu dnia"
    end
  end

  def set_patient
    @patient = Patient.find_by(id: params[:id])
    if @patient.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego pacjent"
    end
  end

  #admin has access to everything
  #new, create, edit, update, destroy -> dietician
  #index -> dietician and patient
  def check_access
    result = false
    if current_user.is_a? Admin
      result = true
    elsif !@template_day.nil?
      result = @template_day.patient.dietician.id == current_user.id
    elsif !@patient.nil?
      result = @patient.id == current_user.id or @patient.dietician.id == current_user.id
    end
    unless result
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
