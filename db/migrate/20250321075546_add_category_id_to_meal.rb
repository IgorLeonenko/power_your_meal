class AddCategoryIdToMeal < ActiveRecord::Migration[8.0]
  def change
    add_reference :meals, :category, foreign_key: { on_delete: :nullify }, index: true
  end
end
