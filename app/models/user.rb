class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_meals, through: :favorites, source: :meal

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
