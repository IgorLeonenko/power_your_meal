# for future usage
# idea is in gathering 10 random meals and saving them to the database once a day, for example
class GatherMealsJob < ApplicationJob
  queue_as :default

  def perform
    (1..10).each do
      Themealdb.new.get_random_meal
    end
  end
end
