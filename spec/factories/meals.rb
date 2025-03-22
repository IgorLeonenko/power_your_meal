FactoryBot.define do
  factory :meal do
    sequence(:name) { |n| "Meal #{n}" }
    sequence(:external_id) { |n| "ext_#{n}" }
    category { nil }

    trait :with_category do
      category
    end

    trait :with_favorites do
      transient do
        users_count { 2 }
      end

      after(:create) do |meal, evaluator|
        create_list(:favorite, evaluator.users_count, meal: meal)
      end
    end
  end
end
