class MealsProductsRelationship < ApplicationRecord
  belongs_to :product, class_name: "Product"
  belongs_to :meal, class_name: "Meal"
  validates :product_id, presence: true
  validates :meal_id, presence: true

  after_create :update_meal_numbers
  after_update :update_meal_numbers
  after_destroy :update_meal_numbers

  def update_meal_numbers
    self.meal.update_numbers
  end
end
