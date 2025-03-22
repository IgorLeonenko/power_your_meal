require 'rails_helper'

RSpec.describe GatherMealsJob, type: :job do
  describe '#perform' do
    let!(:category) { create(:category, name: 'Breakfast') }

    it 'fetches and saves 10 random meals' do
      responses = 10.times.map do |i|
        {
          status: 200,
          body: {
            meals: [ {
              idMeal: "12345#{i}",
              strMeal: "Test Random Meal #{i + 1}",
              strCategory: category.name,
              strMealThumb: "https://example.com/meal#{i + 1}.jpg",
              strInstructions: "Test instructions #{i + 1}",
              strIngredient1: "Ingredient #{i + 1}",
              strMeasure1: "#{i + 1} cup"
            } ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        }
      end

      stub_request(:get, "https://themealdb.com/api/json/v1/1//random.php").
        with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        ).
        to_return(*responses)

      expect { GatherMealsJob.perform_now }.to change(Meal, :count).by(10)

      # Verify the saved meals
      last_meal = Meal.last
      expect(last_meal.name).to eq("Test Random Meal 10")
      expect(last_meal.category).to eq(category)
      expect(last_meal.image_url).to eq("https://example.com/meal10.jpg")
      expect(last_meal.instructions).to eq("Test instructions 10")
      expect(last_meal.ingridients).to eq({ "1" => "Ingredient 10" })
      expect(last_meal.measurements).to eq({ "1" => "10 cup" })
    end

    it 'handles API errors gracefully' do
      20.times do
        stub_request(:get, "https://themealdb.com/api/json/v1/1//random.php").
          to_return(status: 500, body: { meals: [] }.to_json)
      end

      expect(Meal.count).to eq(0)
    end
  end
end
