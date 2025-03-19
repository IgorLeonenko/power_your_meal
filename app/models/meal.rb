class Meal < ApplicationRecord
  validates :name, presence: true
  validates :external_id, presence: true
end
