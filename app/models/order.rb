# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  has_many :order_line_items, dependent: :destroy

  accepts_nested_attributes_for :order_line_items

  enum status: { not_placed: 0, ordered: 1, paid: 2, cancelled: 3, completed: 4 }
end
