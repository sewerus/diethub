class RecipesController < ApplicationController
  before_action :set_meal, only: [:create]
  before_action :set_recipe, only: [:edit, :destroy]
  before_action :admin_or_author_only

  def create
    recipe = Recipe.create_for_meal(@meal, current_user)
    if !recipe.nil?
      redirect_to edit_recipe_path(recipe)
    else
      redirect_to meal_path(@meal), alert: "Nie udało się utworzyć przepisu"
    end
  end

  def edit
  end

  def destroy
  end

  protected

  def admin_or_author_only
    if (!@meal.nil? and !@meal.can_be_edited?(current_user)) or (!@recipe.nil? and !@recipe.can_edit?(current_user))
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end

  def set_meal
    @meal = Meal.find_by(id: params[:meal_id])
    if @meal.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego posiłku"
    end
  end

  def set_recipe
    @recipe = Recipe.find_by(id: params[:id])
    if @recipe.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego przepisu"
    end
  end
end
