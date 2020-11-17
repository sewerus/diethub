class Step < ApplicationRecord
  belongs_to :recipe

  include RailsSortable::Model
  set_sortable :order_number

  default_scope -> {
    order(:order_number)
  }

  before_destroy :fix_order

  def self.new_in_recipe(recipe)
    step = Step.new
    step.recipe = recipe
    step.order_number = recipe.steps.count
    step.save!
    step
  end

  def fix_order
    self.recipe.steps.where("order_number > ?", self.order_number).each do |later_stage|
      later_stage.update(order_number: later_stage.order_number-1)
    end
  end
end
