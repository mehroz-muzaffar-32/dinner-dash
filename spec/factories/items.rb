# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    after(:build) do |item|
      item.categories = build_list(:category, 1)
    end

    title { Faker::Food.unique.dish }
    description { Faker::Food.description }
    price { 410 }

    trait :price do
      sequence(:price, [230, 450, 670, 510, 340].cycle)
    end

    trait :restaurant do
      association :restaurant
    end
  end
end
