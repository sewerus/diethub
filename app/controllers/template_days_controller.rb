class TemplateDaysController < ApplicationController
  before_action :set_template_day, only: [:edit, :update, :destroy]
  before_action :set_patient, only: [:index, :new]
  before_action :admin_and_dietician_only
  
  def index
  end
  
  def new
    @template_day = TemplateDay.new
    @template_day.patient = @patient
  end
  
  def create
    @template_day = TemplateDay.new(template_day_params)

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

  def admin_and_dietician_only
    if !(current_user.is_a? Admin) and !(!@patient.nil? and @patient.dietician.id == current_user.id) and !(!@template_day.nil? and @template_day.patient.dietician.id == current_user.id)
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
