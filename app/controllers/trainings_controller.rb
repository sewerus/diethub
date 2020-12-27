class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :destroy]
  before_action :set_patient, only: [:new]
  before_action :set_date, only: [:new]
  before_action :check_access, except: [:new, :create]

  def new
    @training = Training.new
    @training.patient = @patient
    @training.date = @date
    check_access
  end

  def create
    @training = Training.new(training_params)
    check_access

    if @training.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to days_path(@training.day.patient), alert: 'Nie udało się zapisać zmian.'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @training.update_attributes(training_params)
      respond_to do |format|
        format.js
      end
    else
      redirect_to days_path(@training.day.patient), alert: 'Nie udało się zapisać zmian.'
    end
  end

  def destroy
    @training.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def training_params
    params.require(:training).permit(:patient_id, :date, :hour, :minute, :time_length, :description)
  end

  def set_training
    @training = Training.find_by(id: params[:id])
    if @training.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego szablonu dnia"
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
  #new, create, edit, update, destroy -> dietician
  def check_access
    result = false
    if current_user.is_a? Admin
      result = true
    elsif !@training.nil?
      patient = @training.patient
      result = patient.id == current_user.id or patient.dietician.id == current_user.id
    end
    unless result
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
