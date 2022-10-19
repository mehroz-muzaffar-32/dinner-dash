# frozen_string_literal: true

FactoryBot.define do
  factory :line_item do
    quantity_ordered { 7 }

    association :container, factory: :cart

    trait :item do
      association :item, :restaurant
    end
  end
end
