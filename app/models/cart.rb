# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :line_items, as: :container, dependent: :destroy
  has_many :items, through: :line_items
  belongs_to :user
  belongs_to :restaurant, optional: true

  def total_price
    line_items.sum(&:sub_total)
  end
end
