class Recipe < ApplicationRecord
  has_many :ingredient_recipes, dependent: :destroy

  has_many :ingredients, through: :ingredient_recipes

  has_many :favorites, dependent: :destroy
  
  has_one_attached :photo

  scope :filtered_by_ingredient, ->(ingredient_id) {
    includes(:ingredients).where( ingredients: { id: ingredient_id } )
  }

  scope :filtered_by_ingredients, ->(ingredients) {
    recipes = filtered_by_ingredient(ingredients.first)
    ingredients[1..-1].each do |ingredient_id|
      recipes = recipes.where(recipes: { id: filtered_by_ingredient(ingredient_id) })
    end
    recipes
  }
end
