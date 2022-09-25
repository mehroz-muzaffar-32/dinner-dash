# frozen_string_literal: true

json.extract! order, :id, :status, :total_price, :created_at, :updated_at
json.user order.user.full_name
json.restaurant order.restaurant.name
json.url order_path(order)
