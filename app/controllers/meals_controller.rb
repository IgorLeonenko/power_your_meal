class MealsController < ApplicationController
  before_action :set_meal, only: %i[show toggle_favorite]

  def index
    @categories = Category.all
    @featured_meals = Meal.order("RANDOM()").limit(3)

    meals = Meal.all
    meals = meals.by_name(params[:query]) if params[:query].present?
    meals = meals.by_category(params[:categories]) if params[:categories].present?
    meals = meals.order(name: :desc)

    @pagy, @meals = pagy(meals)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  def get_random_meal
    meal = Themealdb.new.get_random_meal
    return redirect_to meal_path(meal) if meal

    flash[:alert] = "Failed to fetch random meal. Please try again."
    redirect_to meals_path
  end

  def toggle_favorite
    favorite =  Current.user.favorites.find_by(meal: @meal)
    if favorite
      favorite.destroy
    else
      Current.user.favorites.create(meal: @meal)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: meals_path) }
      format.turbo_stream
    end
  end

  def my_favorites
    meals = Current.user.favorite_meals
    @pagy, @meals = pagy(meals)
  end

  private

  def set_meal
    @meal ||= Meal.find(params[:id])
  end
end
