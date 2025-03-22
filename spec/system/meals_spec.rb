require 'rails_helper'

RSpec.describe 'Meals', type: :system do
  include ActionView::RecordIdentifier
  let!(:user) { create(:user) }
  let!(:category) { create(:category, name: 'Breakfast') }
  let!(:meal) { create(:meal, name: 'Pancakes', category: category) }

  before do
    login_as(user)
    visit meals_path
  end

  describe 'index page' do
    it 'shows all meals' do
      expect(page).to have_content(meal.name)
    end

    it 'allows searching for meals' do
      create(:meal, name: 'Waffles', category: category)

      within '#search_form' do
        fill_in 'query', with: 'Pancakes'
        click_button 'Search'
      end

      expect(page).to have_content('Pancakes')
      expect(page).not_to have_content('Waffles')
    end

    it 'allows filtering by category' do
      other_category = create(:category, name: 'Dinner')
      create(:meal, name: 'Steak', category: other_category)

      within '#search_form' do
        find("label[for='category_#{category.id}'").click
      end

      expect(page).to have_content('Pancakes')
      expect(page).not_to have_content('Steak')
    end
  end

  describe 'random meal' do
    it 'fetches a random meal' do
      stub_request(:get, "https://themealdb.com/api/json/v1/1//random.php").
        with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        ).
        to_return(
          status: 200,
          body: {
            meals: [ {
              idMeal: "12345",
              strMeal: "Test Random Meal",
              strCategory: category.name,
              strMealThumb: "https://example.com/meal.jpg",
              strInstructions: "Test instructions",
              strIngredient1: "Ingredient 1",
              strIngredient2: "Ingredient 2",
              strMeasure1: "1 cup",
              strMeasure2: "2 spoon"
            } ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      click_button 'Surprise me with random receipt'

      expect(page).to have_current_path(meal_path(Meal.last))
      expect(page).to have_content("Test Random Meal")
      expect(page).to have_content("Test instructions")
      expect(page).to have_content("Ingredient 1 : 1 cup")
      expect(page).to have_content("Ingredient 2 : 2 spoon")
      expect(page).to have_css("[id^='ingredient_']", count: 2)
    end
  end

  describe 'favorites' do
    it 'allows toggling meal favorites', js: true do
      within "##{dom_id(meal, :wrapper)}" do
        expect(page).to have_selector("#favorite_#{meal.id} svg[fill='none']", visible: true)

        find("#favorite_#{meal.id}", match: :first).click
        sleep(1)

        expect(user.reload.favorite_meals).to include(meal)

        find("#favorite_#{meal.id}", match: :first).click
        sleep(1)

        expect(user.reload.favorite_meals).not_to include(meal)
      end
    end
  end
end
