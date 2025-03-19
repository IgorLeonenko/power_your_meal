class MealsController < ApplicationController
  def index;end

  def show
    @meal = Meal.find(params[:id])
  end

  def get_random_meal
    meal = ThemealdbClient.new.get_random_meal

    redirect_to meal_path(meal)
  end
end
