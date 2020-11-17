class StepsController < ApplicationController
  before_action :set_recipe, only: :create
  before_action :set_step, only: [:update, :destroy]
  before_action :admin_or_author_only

  def create
    @step = Step.new_in_recipe(@recipe)
  end
  
  def update
    @step.update(step_params)
  end
  
  def destroy
    @step_sortable_id = @step.sortable_id
    @step.destroy
  end
  
  protected

  def admin_or_author_only
    if (!@step.nil? and !@step.recipe.can_edit?(current_user)) or (!@recipe.nil? and !@recipe.can_edit?(current_user))
      redirect_to root_path, alert: "Brak dostępu!"
    end
  end

  def step_params
    params.require(:step).permit(:content)
  end

  def set_recipe
    @recipe = Recipe.find_by(id: params[:id])
    if @recipe.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego przepisu"
    end
  end

  def set_step
    @step = Step.find_by(id: params[:id])
    if @step.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego przepisu"
    end
  end
end
