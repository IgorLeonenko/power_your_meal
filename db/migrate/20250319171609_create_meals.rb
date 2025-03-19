class CreateMeals < ActiveRecord::Migration[8.0]
  def change
    create_table :meals do |t|
      t.string :name, null: false
      t.string :image_url
      t.integer :external_id, null: false
      t.text :instructions
      t.jsonb :ingridients, default: {}
      t.timestamps
    end
  end
end
