# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    factory :cart_with_line_items do
      after(:build) do |cart|
        cart.restaurant = create(:restaurant)
        cart.items = build_list(:item, 5, :price, restaurant: cart.restaurant)
        quantities = [5, 3, 2, 4, 7].cycle
        cart.line_items.each do |line_item|
          line_item.quantity_ordered = quantities.next
        end
      end
    end

    factory :cart_with_a_line_item do
      after(:build) do |cart|
        cart.restaurant = create(:restaurant)
        cart.items = build_list(:item, 1, :price, restaurant: cart.restaurant)
        quantities = [7].cycle
        cart.line_items.each do |line_item|
          line_item.quantity_ordered = quantities.next
        end
      end
    end

    trait :restaurant do
      association :restaurant
    end

    association :user
  end
end
