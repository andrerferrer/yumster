class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if params[:search]
      @ingredients_carbs = Recipe.joins(:ingredients).where(:ingredients => { :id =>
        params[:search][:carbs],
      })
      @ingredients_proteins = Recipe.joins(:ingredients).where(:ingredients => { :id =>
        params[:search][:protein],
      })
      @ingredients_vegetables = Recipe.joins(:ingredients).where(:ingredients => { :id =>
        params[:search][:vegetable],
      })

      @recipes = @ingredients_carbs & @ingredients_protein & @ingredients_vegetable
      if @recipes.present?
        redirect_to selection_path(@recipes.sample)
      else
        # Java Script missing
        redirect_to root_path
      end

    else
      @ingredients_carbs = Ingredient.where(category: "Carb")
      @ingredients_proteins = Ingredient.where(category: "Protein")
      @ingredients_vegetables = Ingredient.where(category: "Vegetable")
    end
  end
end
