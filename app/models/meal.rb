class Meal < ApplicationRecord
  belongs_to :category, optional: true
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user

  validates :name, presence: true
  validates :external_id, presence: true

  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
  scope :by_category, ->(category_ids) { where(category_id: category_ids) }
end
