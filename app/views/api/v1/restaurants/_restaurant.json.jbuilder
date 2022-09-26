# frozen_string_literal: true

json.extract! restaurant, :id, :name, :created_at, :updated_at
json.items_count restaurant.items.size
json.url restaurant_path(restaurant)
