# frozen_string_literal: true

json.extract! item, :id, :title, :description, :price, :status, :created_at, :updated_at
json.restaurant item.restaurant.name
json.photo item.photo.attached? ? url_for(item.photo) : url_for('item_blank_photo.png')
json.url api_v1_item_path(item, format: :json)
