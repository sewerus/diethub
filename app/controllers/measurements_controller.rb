class MeasurementsController < ApplicationController
  before_action :set_measurement, only: [:show, :edit, :update, :destroy]
  before_action :set_patient, only: [:new]
  before_action :set_date, only: [:new]
  before_action :check_access, except: [:new, :create]

  def new
    @measurement = Measurement.new
    @measurement.patient = @patient
    @measurement.date = @date
    check_access
  end

  def create
    @measurement = Measurement.new(measurement_params)
    check_access

    if @measurement.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to days_path(@measurement.day.patient), alert: 'Nie udało się zapisać zmian.'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @measurement.update_attributes(measurement_params)
      respond_to do |format|
        format.js
      end
    else
      redirect_to days_path(@measurement.day.patient), alert: 'Nie udało się zapisać zmian.'
    end
  end

  def destroy
    @measurement.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def measurement_params
    params.require(:measurement).permit(:patient_id, :date, :weight, :sleep_time)
  end

  def set_measurement
    @measurement = Measurement.find_by(id: params[:id])
    if @measurement.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego dnia"
    end
  end

  def set_patient
    @patient = Patient.find_by(id: params[:user_id])
    if @patient.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego pacjent"
    end
  end

  def set_date
    if params[:date].nil? or params[:date].empty? or params[:date].length != 10
      @date = Date.today
    else
      @date = Date.parse(params[:date].gsub("_", "."))
    end
  end

  #admin has access to everything
  #new, create, edit, update, destroy -> dietician, patient
  def check_access
    result = false
    if current_user.is_a? Admin
      result = true
    elsif !@measurement.nil?
      patient = @measurement.patient
      result = patient.id == current_user.id or patient.dietician.id == current_user.id
    end
    unless result
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
