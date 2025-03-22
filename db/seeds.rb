# get all categories
puts("--seed categories--")
list_categories_response = ThemealdbClient.get_by_path("/categories.php")

list_categories_response["categories"].each do |category|
  next if Category.find_by(name: category["strCategory"]).present?

  Category.create(name: category["strCategory"], description: category["strCategoryDescription"])
end

puts("----------------------")
puts("seeding categoeirs done!")
puts("----------------------")

# get meals
puts("--seed meals--")

finished_jobs = 0

Category.all.each do |category|
  response = ThemealdbClient.filter_by_category(category.name.capitalize)["meals"]

  response.first(3).each do |resp|
    get_meal_response = ThemealdbClient.get_by_id(resp["idMeal"])["meals"][0]


    Meal.find_or_create_by!(external_id: get_meal_response["idMeal"]) do |meal|
      meal.name = get_meal_response["strMeal"]
      meal.external_id = get_meal_response["idMeal"]
      meal.category_id = category.id
      meal.image_url = get_meal_response["strMealThumb"]
      meal.instructions = get_meal_response["strInstructions"]

      ingridients_count = get_meal_response.count do |key, value|
        key.start_with?("strIngredient") && value.present?
      end

      meal.ingridients = (1..ingridients_count).each_with_object({}) do |i, hash|
        ingredient = get_meal_response["strIngredient#{i}"]
        hash[i] = ingredient
      end

      meal.measurements = (1..ingridients_count).each_with_object({}) do |i, hash|
        measurement = get_meal_response["strMeasure#{i}"]
        hash[i] = measurement
      end
    end

    finished_jobs += 1
    puts("." * finished_jobs)
  end
end

puts("----------------------")
puts("seeding meals done!")
puts("----------------------")
