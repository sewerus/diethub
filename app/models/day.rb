class Day < ApplicationRecord
  belongs_to :patient
  belongs_to :template_day
  has_many :day_parts, dependent: :destroy
  has_many :meals, through: :day_parts

  after_create :add_day_parts

  def self.generate_from_params(params)
    unless params.nil?
      unless params[:day].nil?
        date = params[:day][:date]
        template_day_id = params[:day][:template_day_id]
        if !date.nil? and !template_day_id.nil?
          Day.generate_at(date, template_day_id)
        end
      end
    end
  end

  def self.generate_at(date, template_day_id)
    template_day = TemplateDay.find_by(id: template_day_id)
    day = nil
    unless template_day.nil?
      patient = template_day.patient
      previous_day = patient.get_day(date)
      unless previous_day.nil?
        previous_day.destroy
      end
        day = Day.new
        day.template_day = template_day
        day.patient = patient
        day.date = date
        day.save
    end
    day
  end

  def add_day_parts
    self.template_day.template_day_parts.each do |template_part|
      day_part = DayPart.new
      day_part.day = self
      day_part.title = template_part.title
      day_part.hour = template_part.hour
      day_part.minute = template_part.minute
      day_part.time_margin = template_part.time_margin
      day_part.description = template_part.description
      day_part.save
      day_part.meals += template_part.meals
    end
  end

  def calories
    result = 0
    self.day_parts.each do |day_part|
      day_part.day_part_meals.where(eaten: true).each do |day_part_meal|
        result += day_part_meal.meal.calories
      end
    end
    result
  end

  def fat
    result = 0
    self.day_parts.each do |day_part|
      day_part.day_part_meals.where(eaten: true).each do |day_part_meal|
        result += day_part_meal.meal.fat
      end
    end
    result
  end

  def carbo
    result = 0
    self.day_parts.each do |day_part|
      day_part.day_part_meals.where(eaten: true).each do |day_part_meal|
        result += day_part_meal.meal.carbo
      end
    end
    result
  end

  def protein
    result = 0
    self.day_parts.each do |day_part|
      day_part.day_part_meals.where(eaten: true).each do |day_part_meal|
        result += day_part_meal.meal.protein
      end
    end
    result
  end

  def eaten_meals
    result = 0
    self.day_parts.each do |day_part|
      result += day_part.day_part_meals.where(eaten: true).count
    end
    result
  end

  def all_meals
    result = 0
    self.day_parts.each do |day_part|
      result += day_part.day_part_meals.count
    end
    result
  end

  def self.day_names
    ["Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota", "Niedziela"]
  end

  def self.month_names
    ["Styczeń", "Luty", "Marzec", "Kwiecień", "Maj", "Czerwiec", "Lipiec", "Sierpień", "Wrzesień", "Październik", "Listopad", "Grudzień"]
  end

  def self.date_range(start_date)
    (start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week).to_a
  end

  def self.td_classes_for(day, start_date)
    today = Date.current

    td_class = ['day']
    td_class << "wday-#{day.wday.to_s}"
    td_class << 'today current'         if today == day
    td_class << 'past'          if today > day
    td_class << 'future'        if today < day
    td_class << 'start-date'    if day.to_date == start_date.to_date
    td_class << 'prev-month'    if start_date.month != day.month && day < start_date
    td_class << 'next-month'    if start_date.month != day.month && day > start_date
    td_class << 'current-month' if start_date.month == day.month

    td_class * " "
  end
end
