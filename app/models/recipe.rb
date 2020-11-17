class Recipe < ApplicationRecord
  belongs_to :meal
  belongs_to :author, class_name: "User"
  has_many :steps

  def self.create_for_meal(meal, current_user)
    recipe = Recipe.new
    recipe.meal = meal
    recipe.author = current_user
    if recipe.save
      recipe
    else
      nil
    end
  end

  def can_edit?(user)
    user.is_a? Admin or user.id == self.author_id
  end
end
