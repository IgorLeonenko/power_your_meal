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

  def get_random
    meal = Themealdb.new.get_random_meal
    return redirect_to meal_path(meal) if meal

    flash[:alert] = "Failed to fetch random meal. Please try again."
    redirect_to meals_path
  end

  def toggle_favorite
    favorite = Current.user.favorites.find_by(meal: @meal)
    is_removing = favorite.present?

    if favorite
      favorite.destroy
    else
      Current.user.favorites.create(meal: @meal)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: meals_path) }
      format.turbo_stream do
        if params[:from_favorites].present? && is_removing
          render turbo_stream: turbo_stream.remove(helpers.dom_id(@meal, :wrapper))
        else
          render :toggle_favorite
        end
      end
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
