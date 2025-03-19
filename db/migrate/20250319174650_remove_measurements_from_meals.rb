class RemoveMeasurementsFromMeals < ActiveRecord::Migration[8.0]
  def change
    remove_column :meals, :measurements, :text
  end
end
