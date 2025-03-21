class Category < ApplicationRecord
  has_many :meals

  validates :name, presence: true
end
