class AddMeasurementsToMeals < ActiveRecord::Migration[8.0]
  def change
    add_column :meals, :measurements, :text
  end
end
