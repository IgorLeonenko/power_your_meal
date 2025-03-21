class Meal < ApplicationRecord
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :external_id, presence: true
end
