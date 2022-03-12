class RecipesController < ApplicationController
  def selection
    @recipe = Recipe.find(params[:id])
    @recipes = find_recipes(
      @recipe.ingredient_ids
    )
    @favorite = current_user.favorites.find_by(recipe: @recipe)

    #search with the ingredirents
    #@recipes = Recipe.select(params)
  end

  # yes to the show page with all the instructions
  def show
    @recipes = params[:recipes]
    @recipe = Recipe.find(params[:id])
    @favorite = current_user.favorites.find_by(recipe: @recipe)
  end

  def search
    @recipes = find_recipes(
      [
        query(:protein),
        query(:carb),
        query(:vegetable)
      ]
    )
    if @recipes.present?
      redirect_to selection_path(@recipes.sample)
    else
      # Java Script missing
      redirect_to root_path
    end
  end

  private

  def query(category)
    params.require(:search)[category].to_i
  end

  def find_recipes(ingredients)
    Recipe.filtered_by_ingredients ingredients
  end
end
