FactoryBot.define do
  factory :favorite do
    association :user
    association :meal
  end
end
