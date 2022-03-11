require "open-uri"
require_relative 'scraper'

def build(items, model_class)
  items.each do |item|
    puts "Building #{item[:name]} #{model_class}"
    image_url = item.delete(:image_url)
    model = model_class.create!(item)
    file = URI.open(image_url)
    # model.photo.attach(io: file, filename: "#{item[:name].downcase}.png", content_type: 'image/png')
    yield(model) if block_given?
  end
end

Favorite.destroy_all
Ingredient.destroy_all
IngredientRecipe.destroy_all
Recipe.destroy_all
User.destroy_all

puts 'Create Users'

User.create!(
  email: 'mariela@one.com',
  password: 123456
)

puts 'Create Ingredients'

ingredients = [
  { name: 'Noodles', category: 'Carb', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646318741/development/massa_tpwggn.png' },
  { name: 'Rice', category: 'Carb', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646319962/development/rice_erdar0.png' },
  { name: 'Chicken', category: 'Protein', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646317382/chicken_mmehqa.png' },
  { name: 'Shrimp', category: 'Protein', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646320139/development/shrimp_yh4iir.png' },
  { name: 'Beef', category: 'Protein', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646320828/development/vaquinha_wvsu1s.png' },
  { name: 'Salmon', category: 'Protein', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646321716/development/salmon_ocnmrr.png' },
  { name: 'Carrot', category: 'Vegetable', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646320914/development/carrot_iacktx.png' },
  { name: 'Brocolli', category: 'Vegetable', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646321046/development/broccoli_sumyza.png' },
  { name: 'Onion', category: 'Vegetable', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646321329/development/onion_nsck5e.png' },
  { name: 'Garlic', category: 'Vegetable', image_url: 'https://res.cloudinary.com/dv5lwgtlx/image/upload/v1646321523/development/garlic_dldlss.png' },
]

build(ingredients, Ingredient)

################ SCRAPING START ################

puts 'Start scraping'

# trying new seeds

# Making 8 combinations of ["Rice", "Chicken", "Onion"]
carb = Ingredient.find_by(name: "Rice")
protein = Ingredient.find_by(name: "Chicken")
vegetable = Ingredient.find_by(name: "Onion")
ingredient = "#{carb.name}  #{protein.name}  #{vegetable.name}"

  # puts 'Scraping recipes with ' + ingredient.capitalize
chicken_recipes = scrape(ingredient, 8)

build(chicken_recipes, Recipe) do |recipe|
  ingredients = [carb, protein, vegetable]
  # puts "Adding ingredients #{ingredients.map(&:name)} to #{recipe.name}"
  recipe.ingredients << ingredients
end

# Making 8 combinations of ["Noodles", "Chicken", "Garlic"]

carb = Ingredient.find_by(name: "Noodles")
protein = Ingredient.find_by(name: "Chicken")
vegetable = Ingredient.find_by(name: "Garlic")
ingredient = "#{carb.name}  #{protein.name}  #{vegetable.name}"

  # puts 'Scraping recipes with ' + ingredient.capitalize
chicken_recipes = scrape(ingredient, 8)

build(chicken_recipes, Recipe) do |recipe|
  ingredients = [carb, protein, vegetable]
  # puts "Adding ingredients #{ingredients.map(&:name)} to #{recipe.name}"
  recipe.ingredients << ingredients
end

# create 1 combination of each ingredient - by Andre

# get all ingredients grouped by the category

number_of_recipes = 20
ingredients_grouped_by_category = Ingredient.all.group_by(&:category)

ingredients_grouped_by_category['Carb'].each do |carb|
  ingredients_grouped_by_category['Protein'].each do |protein|
    ingredients_grouped_by_category['Vegetable'].each do |vegetable|
      # for each carb protein and vegetable, scrape it and build it
      ingredient = "#{carb.name}  #{protein.name}  #{vegetable.name}"

      # puts 'Scraping recipes with ' + ingredient.capitalize
      chicken_recipes = scrape(ingredient, number_of_recipes)

      build(chicken_recipes, Recipe) do |recipe|
        ingredients = [carb, protein, vegetable]
        # puts "Adding ingredients #{ingredients.map(&:name)} to #{recipe.name}"
        recipe.ingredients << ingredients
      end
    end
  end
end

################ SCRAPING END ################

puts 'Create Favorites'

Favorite.create!(
  user: User.first,
  recipe: Recipe.first
)
