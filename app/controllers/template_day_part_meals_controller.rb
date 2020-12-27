class TemplateDayPartMealsController < ApplicationController
  before_action :set_template_day_part_meal, only: :destroy
  before_action :set_template_day_part, only: [:new, :create]
  before_action :set_meal, only: :create
  before_action :check_access

  def new
    meals = Meal.all
    filterrific_meals(meals)

    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def create
    @template_day_part_meal = TemplateDayPartMeal.new({template_day_part_id: @template_day_part.id, meal_id: @meal.id})
    if @template_day_part_meal.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to template_day_parts_path(@template_day_part.template_day.patient), alert: 'Nie udało się zapisać zmian.'
    end
  end

  def destroy
    @template_day_part_meal.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def set_template_day_part_meal
    @template_day_part_meal = TemplateDayPartMeal.find_by(id: params[:id])
    if @template_day_part_meal.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego szablonu dnia"
    end
  end

  def set_template_day_part
    @template_day_part = TemplateDayPart.find_by(id: params[:id])
    if @template_day_part.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego szablonu dnia"
    end
  end
  def set_meal
    @meal = Meal.find_by(id: params[:meal_id])
    if @meal.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego posiłku"
    end
  end

  #admin has access to everything
  #new, create, destroy -> dietician
  def check_access
    result = false
    if current_user.is_a? Admin
      result = true
    elsif !@template_day_part.nil?
      result = @template_day_part.template_day.patient.dietician.id == current_user.id
    elsif !@template_day_part_meal.nil?
      result = @template_day_part_meal.template_day_part.template_day.patient.dietician.id == current_user.id
    end
    unless result
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end

  def filterrific_meals(meals, persistence = "meals")
    @filterrific = initialize_filterrific(
        meals,
        params[:filterrific],
        select_options: {
            sorted_by: Meal.options_for_sorted_by
        },
        default_filter_params: {},
        available_filters: [
            :sorted_by,
            :search_author,
            :search_title,
            :search_unit,
            :search_description,
            :search_calories_gte,
            :search_calories_lt,
            :search_fat_gte,
            :search_fat_lt,
            :search_carbo_gte,
            :search_carbo_lt,
            :search_protein_gte,
            :search_protein_lt
        ],
        :persistence_id => persistence,
    ) or return

    @meals = @filterrific.find.page(params[:page]).paginate(:page => params[:page], :per_page => 20)
  end
end
