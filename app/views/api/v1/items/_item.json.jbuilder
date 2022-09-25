# frozen_string_literal: true

json.extract! item, :id, :title, :description, :status, :created_at, :updated_at
json.restaurant item.restaurant.name
json.url api_v1_item_url(item, format: :json)
