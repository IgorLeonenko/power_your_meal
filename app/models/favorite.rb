class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :meal

  validates :user_id, uniqueness: { scope: :meal_id }
end
