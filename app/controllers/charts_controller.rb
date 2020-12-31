class ChartsController < ApplicationController
  before_action :set_patient
  before_action do
    who_can_show_user(@patient)
  end

  def show
  end

  def calories
    time = get_start_end
    start_date = time[0]
    end_date = time[1]
    render json: Day.where(patient_id: @patient.id).where("date >= ? AND date <= ?", start_date, end_date)
                     .map{|d| [d.date.strftime("%d.%m.%Y"), d.calories]}
                     .group_by{|d| d[0]}.map{|k, v| [k, v.map{|d| d[1]}.sum]}.sort_by{|d| d[0].to_date}
  end

  def fat
    time = get_start_end
    start_date = time[0]
    end_date = time[1]
    render json: Day.where(patient_id: @patient.id).where("date >= ? AND date <= ?", start_date, end_date)
                     .map{|d| [d.date.strftime("%d.%m.%Y"), d.fat]}
                     .group_by{|d| d[0]}.map{|k, v| [k, v.map{|d| d[1]}.sum]}.sort_by{|d| d[0].to_date}
  end

  def carbo
    time = get_start_end
    start_date = time[0]
    end_date = time[1]
    render json: Day.where(patient_id: @patient.id).where("date >= ? AND date <= ?", start_date, end_date)
                     .map{|d| [d.date.strftime("%d.%m.%Y"), d.carbo]}
                     .group_by{|d| d[0]}.map{|k, v| [k, v.map{|d| d[1]}.sum]}.sort_by{|d| d[0].to_date}
  end

  def protein
    time = get_start_end
    start_date = time[0]
    end_date = time[1]
    render json: Day.where(patient_id: @patient.id).where("date >= ? AND date <= ?", start_date, end_date)
                     .map{|d| [d.date.strftime("%d.%m.%Y"), d.protein]}
                     .group_by{|d| d[0]}.map{|k, v| [k, v.map{|d| d[1]}.sum]}.sort_by{|d| d[0].to_date}
  end

  def trainings
    time = get_start_end
    start_date = time[0]
    end_date = time[1]
    render json: Training.where(patient_id: @patient.id).where("date >= ? AND date <= ?", start_date, end_date)
                     .map{|d| [d.date.strftime("%d.%m.%Y"), d.time_length.to_f]}
                     .group_by{|d| d[0]}.map{|k, v| [k, v.map{|d| d[1]}.sum]}.sort_by{|d| d[0].to_date}
  end

  def sleep
    time = get_start_end
    start_date = time[0]
    end_date = time[1]
    render json: Measurement.where(patient_id: @patient.id).where("date >= ? AND date <= ?", start_date, end_date)
                     .map{|d| [d.date.strftime("%d.%m.%Y"), d.sleep_time.to_f]}
                     .group_by{|d| d[0]}.map{|k, v| [k, v.map{|d| d[1]}.sum]}.sort_by{|d| d[0].to_date}
  end

  def weight
    time = get_start_end
    start_date = time[0]
    end_date = time[1]
    render json: Measurement.where(patient_id: @patient.id).where("date >= ? AND date <= ?", start_date, end_date)
                     .map{|d| [d.date.strftime("%d.%m.%Y"), d.weight.to_f]}
                     .group_by{|d| d[0]}.map{|k, v| [k, v.map{|d| d[1]}.sum/v.size]}.sort_by{|d| d[0].to_date}
  end

  def plan
    time = get_start_end
    start_date = time[0]
    end_date = time[1]
    render json: Day.where(patient_id: @patient.id).where("date >= ? AND date <= ?", start_date, end_date)
                     .map{|d| [d.date.strftime("%d.%m.%Y"), d.eaten_meals/d.all_meals * 100]}
                     .group_by{|d| d[0]}.map{|k, v| [k, v.map{|d| d[1]}.sum/v.size]}.sort_by{|d| d[0].to_date}
  end
  
  private

  def get_start_end
    start_date = params[:start_date]
    end_date = params[:end_date]
    if start_date.nil?
      start_date = 1.month.ago
    else
      start_date = start_date.gsub("DOT", '.').to_date
    end
    if end_date.nil?
      end_date = Time.now
    else
      end_date = end_date.gsub("DOT", '.').to_date
    end
    [start_date, end_date]
  end

  def set_patient
    @patient = Patient.find_by(id: params[:id])
    if @patient.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego pacjenta!"
    end
  end
end
