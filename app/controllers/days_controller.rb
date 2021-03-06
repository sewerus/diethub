class DaysController < ApplicationController
  before_action :set_patient, only: [
      :index,
      :new,
      :show_day,
      :show_week,
      :show_month,
      :change_week,
      :change_day,
      :change_month
  ]
  before_action :set_date, only: [
      :new,
      :show_day,
      :show_week,
      :show_month,
      :change_week,
      :change_day,
      :change_month
  ]
  before_action :check_access, only: [
      :index,
      :new,
      :show_day,
      :show_week,
      :show_month,
      :change_week,
      :change_day,
      :change_month
  ]

  def index
  end

  def new
    @day = Day.new
    @day.date = @date
    respond_to do |format|
      format.js
    end
  end

  def create
    @day = Day.generate_from_params(params)
    check_access
  end

  def show_day
  end

  def show_week
  end

  def show_month
  end

  def change_week
    respond_to do |format|
      format.js
    end
  end

  def change_day
    respond_to do |format|
      format.js
    end
  end

  def change_month
    respond_to do |format|
      format.js
    end
  end

  private

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

  def check_access
    result = false
    if current_user.is_a? Admin
      result = true
    elsif !@patient.nil?
      result = current_user.id == @patient.id or current_user.id == @patient.dietician.id
    elsif !@day.nil?
      patient = @day.patient
      result = current_user.id == patient.id or current_user.id == patient.dietician.id
    end
    unless result
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end
end
