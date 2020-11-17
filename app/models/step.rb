class Step < ApplicationRecord
  belongs_to :recipe

  include RailsSortable::Model
  set_sortable :order_number

  default_scope -> {
    order(:order_number)
  }

  def self.new_in_recipe(recipe)
    step = Step.new
    step.recipe = recipe
    step.order_number = recipe.steps.count
    step.save!
    step
  end
end
