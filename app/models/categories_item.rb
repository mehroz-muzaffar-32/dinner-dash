# frozen_string_literal: true

class CategoriesItem < ApplicationRecord
  belongs_to :category
  belongs_to :item

  validates :category_id, uniqueness: { scope: :item_id }
end
