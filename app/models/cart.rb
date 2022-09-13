# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :line_items, as: :container, dependent: :destroy
  has_many :items, through: :line_items
  belongs_to :user

  def total_price
    line_items.inject(0) { |sum, line_item| sum + line_item.sub_total }
  end
end
