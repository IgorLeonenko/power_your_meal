class Themealdb
  def get_random_meal
    begin
      response = ThemealdbClient.get_by_path("/random.php")["meals"][0]

      meal = Meal.find_or_initialize_by(external_id: response["idMeal"]) do |meal|
        meal.name = response["strMeal"]
        meal.external_id = response["idMeal"]
        meal.category_id = Category.find_by(name: response["strCategory"]).id
        meal.image_url = response["strMealThumb"]
        meal.instructions = response["strInstructions"]

        ingridients_count = response.count do |key, value|
          key.start_with?("strIngredient") && value.present?
        end

        meal.ingridients = (1..ingridients_count).each_with_object({}) do |i, hash|
          ingredient = response["strIngredient#{i}"]
          hash[i] = ingredient
        end

        meal.measurements = (1..ingridients_count).each_with_object({}) do |i, hash|
          measurement = response["strMeasure#{i}"]
          hash[i] = measurement
        end
      end

      meal.save! if meal.new_record?

    rescue => e
      Rails.logger.error("Failed to fetch or create random meal: #{e.message}; external_meal_id: #{response["idMeal"]}")
      meal = Meal.order("RANDOM()").limit(1).first
    end

    meal
  end
end
