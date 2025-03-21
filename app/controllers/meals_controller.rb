class MealsController < ApplicationController
  def index
    @meals = Meal.all
  end

  def show
    @meal = Meal.find(params[:id])
  end

  def get_random_meal
    meal = Themealdb.new.get_random_meal
    return redirect_to meal_path(meal) if meal

    flash[:alert] = "Failed to fetch random meal. Please try again."
    redirect_to meals_path
  end
end
