class ThemealdbClient
  ROOT_URL = "https://themealdb.com/api/json/v1/1"

  def get_random_meal
    response = HTTParty.get("#{ROOT_URL}/random.php")["meals"][0]

    meal = Meal.find_or_initialize_by(external_id: response["idMeal"]) do |meal|
      meal.name = response["strMeal"]
      meal.external_id = response["idMeal"]
      meal.image_url = response["strMealThumb"]
      meal.instructions = response["strInstructions"]
      meal.ingridients = (1..20).each_with_object({}) do |i, hash|
        ingredient = response["strIngredient#{i}"]
        hash[i] = ingredient if ingredient.present?
      end
    end

    meal.save! if meal.new_record?

    meal
  end
end
