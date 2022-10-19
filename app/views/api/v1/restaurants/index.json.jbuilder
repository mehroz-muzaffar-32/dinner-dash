# frozen_string_literal: true

json.array! @restaurants, partial: 'api/v1/restaurants/restaurant', as: :restaurant
